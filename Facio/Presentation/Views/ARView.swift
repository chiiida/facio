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

    var mainNode: SCNNode?

    func addNode(_ node: FaceNode) {
        faceNodes.append(node)
        if !node.isFaceMask {
            mainNode?.addChildNode(node)
        }
    }

    func updateFeatures(using anchor: ARFaceAnchor) {
        faceNodes.forEach { node in
            if node.isFaceMask {
                let material = SCNMaterial()
                material.lightingModel = .physicallyBased
                material.diffuse.contents = node.image
                material.transparency = 1.0
                mainNode?.geometry?.firstMaterial = material
            } else {
                let child = mainNode?.childNode(withName: node.name ?? "", recursively: false) as? FaceNode
                let vertices = node.indices.map { anchor.geometry.vertices[$0] }
                child?.updatePosition(for: vertices)
            }
        }
    }
}
