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

    let isFaceMask: Bool

    init(
        at indices: [Int],
        isFaceMask: Bool = false,
        width: CGFloat = 0.1,
        height: CGFloat = 0.1
    ) {
        self.indices = indices
        self.isFaceMask = isFaceMask
        self.width = width
        self.height = height

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
        self.image = image
        let imageRatio = image.size.width / image.size.height
        let isLandscapeImg = image.size.width > image.size.height
        if let plane = geometry as? SCNPlane {
            plane.width = isLandscapeImg ? 0.2 : 0.2 * imageRatio
            plane.height = isLandscapeImg ? 0.2 * (1 / imageRatio) : 0.2
            plane.firstMaterial?.diffuse.contents = image
            plane.firstMaterial?.isDoubleSided = true
        }
    }
}
