//
//  HomeViewController+ARSCNViewDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 25/1/2565 BE.
//

import ARKit

extension HomeViewController: ARSCNViewDelegate {
    
    func addSkinSmoothing(faceGeometry: ARSCNFaceGeometry) {
        guard let shaderURL = Bundle.main.url(forResource: "SkinSmoothing", withExtension: "shader"),
            let modifier = try? String(contentsOf: shaderURL)
            else { fatalError("Can't load shader modifier from bundle.") }
        faceGeometry.shaderModifiers = [ .geometry: modifier]
    }


    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let device: MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let material = faceGeometry?.firstMaterial
        material?.transparency = 0.2
//        material?.diffuse.contents = arView.scene.background.contents
//        material?.lightingModel = .constant

        let node = SCNNode(geometry: faceGeometry)
        node.name = "mainNode"
        arView.scene.rootNode.addChildNode(node)
//
//        guard let shaderURL = Bundle.main.url(forResource: "SkinSmoothing", withExtension: "shader"),
//            let modifier = try? String(contentsOf: shaderURL)
//            else { fatalError("Can't load shader modifier from bundle.") }
//        faceGeometry?.shaderModifiers = [.geometry: modifier]

        arView.mainNode = node
        arView.updateFeatures(using: faceAnchor)
        arView.updateParticle()

        return node
    }

    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor
    ) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }

        faceGeometry.update(from: faceAnchor.geometry)
        
//        guard let shaderURL = Bundle.main.url(forResource: "SkinSmoothing", withExtension: "shader"),
//            let modifier = try? String(contentsOf: shaderURL)
//            else { fatalError("Can't load shader modifier from bundle.") }
//        faceGeometry.shaderModifiers = [ .geometry: modifier]
        
        arView.mainNode = node
        arView.updateFeatures(using: faceAnchor)
        arView.updateParticle()
    }
}

extension HomeViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
    }
}
