//
//  HomeViewController+ToolsViewDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import ARKit

extension HomeViewController: ToolsViewDelegate {

    func didTapEditButton(_ node: SCNNode) {
        // TODO: handle editing drawing
    }

    func didTapRemoveButton(_ node: SCNNode) {
        arView.removeNode(node)
        hideARTools()
    }
    
    func didUpdatePositionZ(_ node: SCNNode, posZ: Float) {
        guard let node = node as? FaceNode else { return }
        let position = SCNVector3(x: node.position.x, y: node.position.y, z: posZ)
        arView.updatePosition(for: node, with: position)
    }
}
