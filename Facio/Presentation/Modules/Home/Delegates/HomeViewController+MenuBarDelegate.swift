//
//  HomeViewController+MenuBarDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import UIKit

extension HomeViewController: MenuBarDelegate {
    
    func didTapCameraButton() {
        hideARTools()

        let image = arView.snapshot()
        let previewVC = SnapshotPreviewViewController(image: image)
        let navVC = UINavigationController(rootViewController: previewVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    func didTapRecordButton(_ isRecording: Bool) {
        hideARTools()
        if isRecording {
            arRecoder?.start(captureType: .imageCapture)
        } else {
            arRecoder?.stop { videoPath in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let imageSize = self.arView.snapshot().size
                    let previewVC = VideoPreviewViewController(videoPath: videoPath, arRecoder: self.arRecoder)
                    previewVC.setVideoSize(imageSize)
                    let navVC = UINavigationController(rootViewController: previewVC)
                    navVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(navVC, animated: true)
                }
            }
        }
    }
    
    func didTapImageButton() {
        hideARTools()

        let imagepickerVC = ImagePickerViewController()
        imagepickerVC.delegate = self
        present(imagepickerVC, animated: true, completion: nil)
    }
    
    func didTapDrawButton() {
        hideARTools()

        let drawingBoardVC = DrawingBoardViewController()
        drawingBoardVC.delegate = self
        let navVC = UINavigationController(rootViewController: drawingBoardVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    func didTapTextButton() {
        hideARTools()

        let textEditorVC = TextEditorViewController()
        textEditorVC.delegate = self
        let navVC = UINavigationController(rootViewController: textEditorVC)
        navVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    func didTapthreeDButtonButton() {
        menuBar.isHidden = true
        threeDBar.isHidden = false
        backButton.isHidden = false
    }
    
    @objc func didTapBackButton() {
        menuBar.isHidden = false
        threeDBar.isHidden = true
        particleBar.isHidden = true
        backButton.isHidden = true
    }
}
