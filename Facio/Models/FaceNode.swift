//
//  FaceNode.swift
//  Facio
//
//  Created by Chananchida Fuachai on 16/1/2565 BE.
//

import SceneKit

class FaceNode: SCNNode {

    var indices: [Int]
    var image: UIImage?
    var width: CGFloat?
    var height: CGFloat?
    var material: SCNMaterial?

    init(
        at indices: [Int],
        width: CGFloat = 0.1,
        height: CGFloat = 0.1
    ) {
        self.indices = indices
        self.width = width
        self.height = height
        self.material = SCNMaterial()

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
}
