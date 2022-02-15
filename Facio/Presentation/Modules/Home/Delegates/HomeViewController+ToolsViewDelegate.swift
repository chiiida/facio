//
//  HomeViewController+ToolsViewDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import ARKit

extension HomeViewController: ToolsViewDelegate {

    func didTapEditButton(_ node: SCNNode) {
        guard let node = node as? FaceNode else { return }
    }

    func didTapRemoveButton(_ node: SCNNode) {
        arView.removeNode(node)
        hideARTools()
    }
}
