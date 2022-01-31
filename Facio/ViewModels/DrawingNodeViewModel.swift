//
//  DrawingNodeViewModel.swift
//  Facio
//
//  Created by Chananchida Fuachai on 1/2/2565 BE.
//

import UIKit
import SceneKit

class DrawingNodeViewModel: FaceNodeViewModelProtocol {

    var node: FaceNode

    init(node: DrawingNode) {
        self.node = node
    }

    func addImage(_ image: UIImage) {
        node.image = image

        if let node = node as? DrawingNode,
           node.isFaceMask {
            node.material?.lightingModel = .physicallyBased
            node.material?.diffuse.contents = image
            node.material?.transparency = 1.0
        } else {
            if let plane = node.geometry as? SCNPlane {
                plane.width = image.size.width / 5_000
                plane.height = image.size.height / 5_000
                plane.firstMaterial?.diffuse.contents = image
                plane.firstMaterial?.isDoubleSided = true
            }
        }
    }
}
