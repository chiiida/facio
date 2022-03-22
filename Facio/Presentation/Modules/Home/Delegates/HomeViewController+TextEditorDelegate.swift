//
//  HomeViewController+TextEditorDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 7/3/2565 BE.
//

import ARKit
import SceneKit

extension HomeViewController: TextEditorDelegate {
    
    func didFinishTyping(_ text: String, color: UIColor, size: CGFloat, font: String, width: CGFloat, height: CGFloat) {
        let typedText = SCNText(string: text, extrusionDepth: 0.2)
        typedText.font = UIFont(name: font, size: size)
        typedText.containerFrame = CGRect(origin: .init(x: 0.0, y: 0.0), size: CGSize(width: width, height: height))
        typedText.isWrapped = true
        typedText.alignmentMode = "center"
        typedText.truncationMode = "end"
        
        let material = SCNMaterial()
        material.diffuse.contents = color.cgColor
        typedText.materials = [material]
        
        let node = FaceNode(at: FeatureIndices.nose)
        let timestamp = Date().timeIntervalSince1970
        let textNodeName = "text\(timestamp)"
        node.name = textNodeName
        node.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node.geometry = typedText
        let viewModel = FaceNodeViewModel(node: node)

        arView.addNode(from: viewModel)
    }
}
