//
//  HomeViewController+ARSCNViewDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 25/1/2565 BE.
//

import ARKit

extension SCNMatrix4 {
    /**
     Create a 4x4 matrix from CGAffineTransform, which represents a 3x3 matrix
     but stores only the 6 elements needed for 2D affine transformations.
     
     [ a  b  0 ]     [ a  b  0  0 ]
     [ c  d  0 ]  -> [ c  d  0  0 ]
     [ tx ty 1 ]     [ 0  0  1  0 ]
     .               [ tx ty 0  1 ]
     
     Used for transforming texture coordinates in the shader modifier.
     (Needs to be SCNMatrix4, not SIMD float4x4, for passing to shader modifier via KVC.)
     */
    init(_ affineTransform: CGAffineTransform) {
        self.init()
        m11 = Float(affineTransform.a)
        m12 = Float(affineTransform.b)
        m21 = Float(affineTransform.c)
        m22 = Float(affineTransform.d)
        m41 = Float(affineTransform.tx)
        m42 = Float(affineTransform.ty)
        m33 = 1
        m44 = 1
    }
}

extension HomeViewController: ARSCNViewDelegate {
    
    func addParticle() {
        if let particle = SCNParticleSystem(named: "Particles/confetti.scnp", inDirectory: "art.scnassets") {
            let particleNode = SCNNode()
            particleNode.addParticleSystem(particle)
            particleNode.scale = SCNVector3Make(0.5, 0.5, 0.5)
            
            let pos = SCNVector3Make(0.0, 1.0, 0.1)
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
