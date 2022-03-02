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
    var panPosition: SCNVector3?
    var isFaceMask: Bool

    init(node: DrawingNode) {
        self.node = node
        isFaceMask = node.isFaceMask
    }

    func addImage(_ image: UIImage) {
        node.image = image

        if let node = node as? DrawingNode, node.isFaceMask {
            node.material.lightingModel = .physicallyBased
            node.material.diffuse.contents = image
            node.material.transparency = 1.0
        } else {
            if let plane = node.geometry as? SCNPlane {
                plane.width = image.size.width / 6_000
                plane.height = image.size.height / 6_000
                plane.firstMaterial?.diffuse.contents = image
                plane.firstMaterial?.isDoubleSided = true
            }

            addHighlightNode()
            hideHighlight()
        }
    }

    func updateMaterial(with material: SCNMaterial) {
        if isFaceMask {
            if let metalness = material.metalness.contents as? Double {
                node.material.metalness.contents = metalness
            }
            
            if let roughness = material.roughness.contents as? Double {
                node.material.roughness.contents = roughness
            }
            
            if material.shininess != 1.0 {
                node.material.shininess = material.shininess
            }
        }
    }
}
