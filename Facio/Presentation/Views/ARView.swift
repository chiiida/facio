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
    private var particleNodeViewModel: ParticleNodeViewModelProtocol = ParticleNodeViewModel()
    private var objectNodeViewModel: ObjectNodeViewModelProtocol = ObjectNodeViewModel()
    
    var lastDragPosition: SCNVector3?
    var selectedNode: SCNNode?
    var panStartZ: CGFloat?
    var mainNode: SCNNode?

    func getViewModel(from node: SCNNode) -> FaceNodeViewModelProtocol? {
        guard let viewModel = nodeViewModels.first(where: {
            $0.node == node
        }) else { return nil }
        return viewModel
    }

    // MARK: - Face Nodes
    
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
    
    func removeNode(_ node: SCNNode) {
        if node == mainNode {
            mainNode?.geometry?.firstMaterial?.diffuse.contents = nil
            mainNode?.geometry?.firstMaterial?.transparency = 0.0
        }
        if let index = nodeViewModels.firstIndex(where: { $0.node == node }) {
            nodeViewModels.remove(at: index)
            node.removeFromParentNode()
        }
    }

    func updateFeatures(using anchor: ARFaceAnchor) {
        nodeViewModels.forEach { viewModel in
            let node = viewModel.node
            if let drawNode = node as? DrawingNode,
               drawNode.isFaceMask {
                mainNode?.geometry?.firstMaterial = node.material
            } else {
                let child = mainNode?.childNode(withName: node.name ?? "", recursively: false) as? FaceNode

                if let panningPosition = viewModel.panPosition {
                    child?.localTranslate(by: panningPosition)
                    child?.position = panningPosition
                } else {
                    let vertices = node.indices.map { anchor.geometry.vertices[$0] }
                    child?.updatePosition(for: vertices)
                    child?.position.z += 0.01
                }
            }
        }
    }

    func updatePosition(for node: FaceNode, with position: SCNVector3) {
        guard let viewModel = getViewModel(from: node)
        else { return }
        viewModel.panPosition = position
        if position.z > 2.0 || position.z < 0.05 {
            viewModel.panPosition?.z = 0.07
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
    
    func updateRotation(for node: FaceNode, with angle: SCNVector3) {
        guard let viewModel = getViewModel(from: node)
        else { return }
        viewModel.originalRotation = angle
    }

    func showHighlight(_ node: FaceNode) {
        guard let viewModel = getViewModel(from: node) else { return }
        viewModel.showHighlight()
    }

    func hideAllHighlights() {
        nodeViewModels.forEach {
            $0.hideHighlight()
        }
    }
    
    // MARK: - Particle
    
    func addParticle(_ particle: Particle) {
        particleNodeViewModel.selectParticle(particle)
    }
    
    func colorParticle(color: UIColor) {
        particleNodeViewModel.currentParticleColor = color
    }
    
    func updateBirthRate(birthRate: CGFloat) {
        particleNodeViewModel.currentBirthRate = birthRate
    }
    
    func updateSpeed(speed: CGFloat) {
        particleNodeViewModel.currentBirthRate = speed
    }
    
    func removeParticle() {
        particleNodeViewModel.removeParticle()
    }
    
    func updateParticle() {
        guard let selectedParticle = particleNodeViewModel.selectedParticle
        else { return }

        let particlePath = "Particles/\(selectedParticle).scnp"
        guard let particle = SCNParticleSystem(named: particlePath, inDirectory: "art.scnassets")
        else { return }

        let particleNode = SCNNode()
        particleNode.addParticleSystem(particle)
        particleNode.scale = SCNVector3Make(0.5, 0.5, 0.5)

        let pos = SCNVector3Make(0.0, 1.0, 0.0)
        particleNode.position = pos
        
        particleNodeViewModel.updateCurrentParticleNode(particleNode)
        
        guard let currentParticleNode = particleNodeViewModel.currentParticleNode
        else { return }
        pointOfView?.addChildNode(currentParticleNode)
    }
    
    // MARK: - 3D objects
    
    func updateThreeDObject() {
        guard let threeDObject = objectNodeViewModel.currentObject else { return }
        mainNode?.addChildNode(threeDObject.rootNode)
    }
    
    func addObject(with type: ObjectType) {
        objectNodeViewModel.addObject(with: type)
    }
    
    func removeObject() {
        objectNodeViewModel.removeObject()
    }
}
