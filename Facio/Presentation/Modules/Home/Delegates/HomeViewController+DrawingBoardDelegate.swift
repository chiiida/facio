//
//  HomeViewController+DrawingBoardDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import UIKit

extension HomeViewController: DrawingBoardDelegate {

    func didFinishDrawing(_ image: UIImage, isFaceMask: Bool) {
        let drawingNode = DrawingNode(at: FeatureIndices.nose, isFaceMask: isFaceMask)
        let timestamp = Date().timeIntervalSince1970
        let drawNodeName = "draw\(timestamp)"
        drawingNode.name = drawNodeName
        let viewModel = DrawingNodeViewModel(node: drawingNode)
        viewModel.addImage(image)
        arView.addNode(from: viewModel)

        hideARTools()

        if isFaceMask {
            resetFaceMaskMenu()
            showFaceMaskMaterialMenu()
        }
    }
}
