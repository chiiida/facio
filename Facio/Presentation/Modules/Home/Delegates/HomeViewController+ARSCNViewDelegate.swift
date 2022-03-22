//
//  HomeViewController+ARSCNViewDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 25/1/2565 BE.
//

import ARKit

extension HomeViewController: ARSCNViewDelegate {
    
    func addParticle() {
        if let particle = SCNParticleSystem(named: "Particles/Stars.scnp", inDirectory: "art.scnassets") {
            let particleNode = SCNNode()
            particleNode.addParticleSystem(particle)
            particleNode.scale = SCNVector3Make(0.5, 0.5, 0.5)
            
            let pos = SCNVector3Make(0.0, 1.0, 0.0)
            particleNode.position = pos
            arView.pointOfView?.addChildNode(particleNode)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let device: MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let material = faceGeometry?.firstMaterial
        material?.transparency = 0.0

        let node = SCNNode(geometry: faceGeometry)
        node.name = "mainNode"
        arView.scene.rootNode.addChildNode(node)
        
        material?.lightingModel = .constant
        
        addParticle()

        arView.mainNode = node
        arView.updateFeatures(using: faceAnchor)

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
        
        addParticle()
        
        arView.mainNode = node
        arView.updateFeatures(using: faceAnchor)
    }
}
