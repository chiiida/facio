//
//  DrawingNode.swift
//  Facio
//
//  Created by Chananchida Fuachai on 31/1/2565 BE.
//

import SceneKit

class DrawingNode: FaceNode {

    let isFaceMask: Bool

    init(
        at indices: [Int],
        isFaceMask: Bool = false,
        width: CGFloat = 0.1,
        height: CGFloat = 0.1
    ) {
        self.isFaceMask = isFaceMask

        super.init(at: indices, width: width, height: height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
