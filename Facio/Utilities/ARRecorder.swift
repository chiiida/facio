//
//  ARRecorder.swift
//  Facio
//
//  Created by Chananchida Fuachai on 9/3/2565 BE.
//

import UIKit
import ARKit
import Photos

// swiftlint:disable force_cast line_length force_unwrapping

class ARRecorder {
    
    var isRecording = false
    var snapshotArray: [[String: Any]] = [[String: Any]]()
    var lastTime: TimeInterval = 0
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    var assetWriter: AVAssetWriter?
    var videoInput: AVAssetWriterInput?
    var audioInput: AVAssetWriterInput?
    
    var arView: ARSCNView
    
    init(arView: ARSCNView) {
        self.arView = arView
    }
    
    func record() {
        lastTime = 0
        isRecording = true
    }
    
    func stopAndSave() {
        isRecording = false
        export()
    }
    
    func stop(_ completionHandler: @escaping (URL) -> Void) {
        isRecording = false
        let videoPath = finishVideo()
        completionHandler(videoPath)
    }
    
    func didUpdateAtTime(time: TimeInterval) {
        if isRecording {
            if lastTime == 0 || (lastTime + 1 / 31) < time {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.lastTime = time
                    let snapshot: UIImage = self.arView.snapshot()
                    let scale = CMTimeScale(NSEC_PER_SEC)
                    
                    self.snapshotArray.append([
                        "image": snapshot,
                        "time": CMTime(
                            value: CMTimeValue((self.arView.session.currentFrame!.timestamp) * Double(scale)),
                            timescale: scale
                        )
                    ])
                }
            }
        }
    }
    
    func export(withName: String = "ar_video", fps: Int = 30) {
        guard let image = snapshotArray.first?["image"] as? UIImage else { return }
        let size = image.size
        
        createURLForVideo(withName: withName) { [weak self] videoURL in
            self?.prepareWriterAndInput(size: size, videoURL: videoURL) { error in
                guard error == nil else { return }
                self?.createVideo(fps: fps, size: size) { _ in
                    guard error == nil else { return }
                    self?.finishVideoRecordingAndSave()
                }
            }
        }
    }
    
    private func createURLForVideo(withName: String, completionHandler: @escaping (URL) -> Void) {
        // Clear the location for the temporary file.
        let temporaryDirectoryURL: URL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let targetURL: URL = temporaryDirectoryURL.appendingPathComponent("\(withName).mp4")
        // Delete the file, incase it exists.
        do {
            try FileManager.default.removeItem(at: targetURL)
        } catch let error {
            NSLog("Unable to delete file, with error: \(error)")
        }
        // return the URL
        completionHandler(targetURL)
    }
    
    private func prepareWriterAndInput(size: CGSize, videoURL: URL, completionHandler: @escaping (Error?) -> Void) {
        
        do {
            self.assetWriter = try AVAssetWriter(outputURL: videoURL, fileType: AVFileType.mp4)
            
            let videoOutputSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: size.width,
                AVVideoHeightKey: size.height
            ]
    
            self.videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)
            self.videoInput?.expectsMediaDataInRealTime = true
            
            guard let videoInput = videoInput else { return }
            
            self.assetWriter?.add(videoInput)
            
            // Create Pixel buffer Adaptor
            
            let sourceBufferAttributes: [String: Any] = [
                (kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32ARGB),
                (kCVPixelBufferWidthKey as String): Float(size.width),
                (kCVPixelBufferHeightKey as String): Float(size.height)
            ] as [String: Any]
            
            self.pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoInput, sourcePixelBufferAttributes: sourceBufferAttributes)
    
            self.assetWriter?.startWriting()
            self.assetWriter?.startSession(atSourceTime: CMTime.zero)
            completionHandler(nil)
        } catch {
            print("Failed to create assetWritter with error : \(error)")
            completionHandler(error)
        }
    }
    
    private func createVideo(fps: Int, size: CGSize, completionHandler: @escaping (String?) -> Void) {
        var currentframeTime: CMTime = CMTime.zero
        var currentFrame: Int = 0
        
        let startTime: CMTime = (snapshotArray[0])["time"] as! CMTime
        
        guard let videoInput = videoInput,
              let pixelBufferAdaptor = pixelBufferAdaptor
        else { return }
        
        while currentFrame < snapshotArray.count {
            
            // When the video input is ready for more media data...
            if videoInput.isReadyForMoreMediaData {
                print("processing current frame :: \(currentFrame)")
                // Get current CG Image
                let currentImage: UIImage = (snapshotArray[currentFrame])["image"] as! UIImage
                let currentCGImage: CGImage? = currentImage.cgImage
                
                guard currentCGImage != nil else {
                    completionHandler("failed to get current cg image")
                    return
                }
                
                // Create the pixel buffer
                self.createPixelBufferFromUIImage(image: currentImage) { [weak self] error, pixelBuffer in
                    guard let self = self else { return }
                    guard error == nil else {
                        completionHandler("failed to get pixelBuffer")
                        return
                    }
                    
                    // Calc the current frame time
                    currentframeTime = (self.snapshotArray[currentFrame])["time"] as! CMTime - startTime
                    
                    guard let pixelBuffer = pixelBuffer else { return }
                    // Add pixel buffer to video input
                    pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: currentframeTime)
                    
                    // increment frame
                    currentFrame += 1
                }
            }
        }
        
        // FINISHED
        completionHandler(nil)
    }

    private func createPixelBufferFromUIImage(image: UIImage, completionHandler: @escaping (String?, CVPixelBuffer?) -> Void) {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            completionHandler("Failed to create pixel buffer", nil)
            return
        }
        
        guard let pixelBuffer = pixelBuffer else { return }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        guard let context = context else { return }
        
        UIGraphicsPushContext(context)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        completionHandler(nil, pixelBuffer)
    }
    
    private func finishVideo() -> URL {
        videoInput?.markAsFinished()
        guard let assetWriter = assetWriter else {
            return URL(fileURLWithPath: "")
        }

        assetWriter.finishWriting {
            print("finished record video")
        }
        snapshotArray.removeAll()
        return assetWriter.outputURL
    }
    
    private func finishVideoRecordingAndSave() {
        guard let videoInput = videoInput else { return }
        
        videoInput.markAsFinished()
        self.assetWriter?.finishWriting(completionHandler: { [weak self] in
            guard let assetWriter = self?.assetWriter else { return }
            
            PHPhotoLibrary.requestAuthorization { _ in
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: assetWriter.outputURL)
                }) { [weak self] saved, _ in
                    
                    if saved {
                        print("Saved video")
                    }
                    // Clear the original array
                    self?.snapshotArray.removeAll()
                }
            }
        })
    }
}
