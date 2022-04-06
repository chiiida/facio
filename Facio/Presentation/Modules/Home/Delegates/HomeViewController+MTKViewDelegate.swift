//
//  HomeViewController+MTKViewDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 27/3/2565 BE.
//

import MetalKit

extension MTKView: RenderDestinationProvider {}

extension HomeViewController: MTKViewDelegate {
    
    // Called whenever view changes orientation or layout is changed
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderer?.drawRectResized(size: size)
    }

    // Called whenever the view needs to render
    func draw(in view: MTKView) {
//        print("drawing")
//        if let currentDrawable = view.currentDrawable,
//           let commandBuffer = renderer?.commandQueue.makeCommandBuffer(),
//           let texture = renderer?.capturedImageTextureY {
//
//            let inputImage = CIImage(mtlTexture: texture)!.oriented(.down)
//            filter.setValue(inputImage, forKey: kCIInputImageKey)
//            filter.setValue(10.0, forKey: kCIInputRadiusKey)
//
//            context.render(
//                filter.outputImage!,
//                to: currentDrawable.texture,
//                commandBuffer: commandBuffer,
//                bounds: arView.bounds,
//                colorSpace: colorSpace
//            )
//
//            commandBuffer.present(currentDrawable)
//            commandBuffer.commit()
//        }
        
        renderer?.update()
    }
}
