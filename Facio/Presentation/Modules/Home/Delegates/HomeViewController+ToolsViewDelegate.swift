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
}
