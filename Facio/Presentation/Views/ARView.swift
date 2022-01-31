//
//  ARView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 16/1/2565 BE.
//

import ARKit
import UIKit

final class ARView: ARSCNView {

    private var nodeViewModels = [FaceNodeViewModelProtocol]()

    var mainNode: SCNNode?

    func addNode(from viewModel: FaceNodeViewModelProtocol) {
        nodeViewModels.append(viewModel)

        if let drawingNode = viewModel.node as? DrawingNode,
           drawingNode.isFaceMask { return }
        mainNode?.addChildNode(viewModel.node)
    }

    func updateFeatures(using anchor: ARFaceAnchor) {
        nodeViewModels.forEach { viewModel in
            let node = viewModel.node
            if let drawNode = node as? DrawingNode,
               drawNode.isFaceMask {
                mainNode?.geometry?.firstMaterial = node.material
            } else {
                let child = mainNode?.childNode(withName: node.name ?? "", recursively: false) as? FaceNode
                let vertices = node.indices.map { anchor.geometry.vertices[$0] }
                child?.updatePosition(for: vertices)
            }
        }
    }
}
