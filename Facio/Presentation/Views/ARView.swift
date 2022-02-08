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
        if let drawingNode = viewModel.node as? DrawingNode, drawingNode.isFaceMask {
            nodeViewModels.removeAll {
                if let drawNode = $0.node as? DrawingNode, drawNode.isFaceMask {
                    return true
                }
                return false
            }
            nodeViewModels.append(viewModel)
            return
        }
        mainNode?.addChildNode(viewModel.node)
        nodeViewModels.append(viewModel)
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
                child?.position.z += 0.01
            }
        }
    }

    func updateFaceMask(with material: SCNMaterial) {
        guard let faceMaskViewModel = nodeViewModels.first(where: {
            if let drawNode = $0 as? DrawingNodeViewModel, drawNode.isFaceMask {
                return true
            }
            return false
        }) else { return }

        faceMaskViewModel.updateMaterial(with: material)
    }
}
