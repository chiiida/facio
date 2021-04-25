//
//  ARView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 25/4/2564 BE.
//

import Foundation
import ARKit
import SwiftUI

// MARK: - ARViewIndicator
struct ARViewIndicator: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARView
    @Binding var showFaceMesh: Bool
    @Binding var inputImage: UIImage?
    
    func makeUIViewController(context: Context) -> ARView {
        return ARView(showFaceMesh: showFaceMesh)
    }
    
    func updateUIViewController(_ uiViewController:
                                    ARViewIndicator.UIViewControllerType, context:
                                        UIViewControllerRepresentableContext<ARViewIndicator>) {
        uiViewController.showFaceMesh = self.showFaceMesh
        if inputImage != nil {
            uiViewController.currentNoseNode?.addImage(image: inputImage!)
        }
        print(uiViewController.showFaceMesh)
    }
}

class ARView: UIViewController, ARSCNViewDelegate {
    let noseOptions = ["nose01", "nose02", "nose03", "nose04", "nose05", "nose06", "nose07", "nose08", "nose09"]
    let leftEyeOptions = ["leftEye"]
    let rightEyeOptions = ["rightEye"]
    let features = ["nose", "leftEye", "rightEye", "mouth", "hat"]
    let featureIndices = [[9], [42], [1064], [24, 25], [20]]
    
    var arView: ARSCNView {
        return self.view as! ARSCNView
    }
    
    var showFaceMesh: Bool
    
    var currentNoseNode: FaceNode?
    
    init(showFaceMesh: Bool) {
        self.showFaceMesh = showFaceMesh
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ARSCNView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arView.delegate = self
        arView.scene = SCNScene()
    }
    
    // MARK: - Functions for standard AR view handling
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
        arView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    func sessionWasInterrupted(_ session: ARSession) {}
    
    func sessionInterruptionEnded(_ session: ARSession) {}
    func session(_ session: ARSession, didFailWithError error: Error)
    {}
    func session(_ session: ARSession, cameraDidChangeTrackingState
                    camera: ARCamera) {}
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: arView)
        let results = arView.hitTest(location, options: nil)
        if let result = results.first,
            let node = result.node as? FaceNode {
            node.next()
        }
    }
    
    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        for (feature, indices) in zip(features, featureIndices) {
            let child = node.childNode(withName: feature, recursively: false) as? FaceNode
            let vertices = indices.map { anchor.geometry.vertices[$0] }
            child?.updatePosition(for: vertices)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let device: MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return nil
        }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)

        if showFaceMesh {
            // Face mesh
            node.geometry?.firstMaterial?.fillMode = .lines
        } else {
            // Hide face mesh
            node.geometry?.firstMaterial?.transparency = 0
        }
        
        let noseNode = FaceNode(with: noseOptions)
        noseNode.name = "nose"
        node.addChildNode(noseNode)
        currentNoseNode = noseNode
        
//        let leftEyeNode = FaceNode(with: leftEyeOptions)
//        leftEyeNode.name = "leftEye"
//        node.addChildNode(leftEyeNode)
//
//        let rightEyeNode = FaceNode(with: rightEyeOptions)
//        rightEyeNode.name = "rightEye"
//        node.addChildNode(rightEyeNode)
        
        updateFeatures(for: node, using: faceAnchor)
        
        return node
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        updateFeatures(for: node, using: faceAnchor)
    }
}

