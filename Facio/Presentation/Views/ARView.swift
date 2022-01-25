//
//  ARView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 16/1/2565 BE.
//

import ARKit
import UIKit

final class ARView: ARSCNView {

    private var faceNodes: [FaceNode] = []
    
    func addNode(_ node: FaceNode) {
        faceNodes.append(node)
    }

    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        faceNodes.forEach { faceNode in
            node.addChildNode(faceNode)
        }

        for faceNode in faceNodes {
            let child = node.childNode(withName: faceNode.name ?? "", recursively: false) as? FaceNode
            let vertices = faceNode.indices.map { anchor.geometry.vertices[$0] }
            child?.updatePosition(for: vertices)
        }
    }
}
