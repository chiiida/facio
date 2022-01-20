//
//  FaceNode.swift
//  Facio
//
//  Created by Chananchida Fuachai on 16/1/2565 BE.
//

import SceneKit

class FaceNode: SCNNode {

    var indices: [Int]

    init(at indices: [Int], width: CGFloat = 0.1, height: CGFloat = 0.1) {
        self.indices = indices

        super.init()

        let plane = SCNPlane(width: width, height: height)
        plane.firstMaterial?.isDoubleSided = true

        geometry = plane
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom functions

extension FaceNode {

    func updatePosition(for vectors: [vector_float3]) {
        let newPos = vectors.reduce(vector_float3(), +) / Float(vectors.count)
        position = SCNVector3(newPos)
    }

    func addImage(image: UIImage) {
        if let plane = geometry as? SCNPlane {
            plane.width = image.size.width / 5_000
            plane.height = image.size.height / 5_000
            plane.firstMaterial?.diffuse.contents = image
            plane.firstMaterial?.isDoubleSided = true
        }
    }
}
