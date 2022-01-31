//
//  FaceNodeViewModel.swift
//  Facio
//
//  Created by Chananchida Fuachai on 1/2/2565 BE.
//

import SceneKit
import UIKit

protocol FaceNodeViewModelProtocol: AnyObject {

    var node: FaceNode { get set }

    func updateMaterial(with material: SCNMaterial)
    func addImage(_ image: UIImage)
}

class FaceNodeViewModel: FaceNodeViewModelProtocol {

    var node: FaceNode

    init(node: FaceNode) {
        self.node = node
    }

    func addImage(_ image: UIImage) {
        node.image = image
        let imageRatio = image.size.width / image.size.height
        let isLandscapeImg = image.size.width > image.size.height
        if let plane = node.geometry as? SCNPlane {
            plane.width = isLandscapeImg ? 0.2 : 0.2 * imageRatio
            plane.height = isLandscapeImg ? 0.2 * (1 / imageRatio) : 0.2
            plane.firstMaterial?.diffuse.contents = image
            plane.firstMaterial?.isDoubleSided = true
        }
    }
}

extension FaceNodeViewModelProtocol {

    func updateMaterial(with material: SCNMaterial) {
        node.material = material
    }
}
