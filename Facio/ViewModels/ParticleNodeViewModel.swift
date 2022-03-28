//
//  ParticleNodeViewModel.swift
//  Facio
//
//  Created by Chananchida Fuachai on 25/3/2565 BE.
//

import ARKit

enum Particle: String {
    
    case confetti
    case bokeh
    case stars
    case rain
}

protocol ParticleNodeViewModelProtocol: AnyObject {
    
    var selectedParticle: Particle? { get set }
    var currentParticleNode: SCNNode? { get set }
    var currentSpeedFactor: CGFloat? { get set }
    var currentBirthRate: CGFloat? { get set }
     
    func selectParticle(_ particle: Particle)
    func removeParticle()
    func updateCurrentParticleNode(_ node: SCNNode)
}

class ParticleNodeViewModel: ParticleNodeViewModelProtocol {
    
    var selectedParticle: Particle?
    var currentParticleNode: SCNNode?
    var currentSpeedFactor: CGFloat?
    var currentBirthRate: CGFloat?
    
    
    func selectParticle(_ particle: Particle) {
        selectedParticle = particle
    }
    
    func removeParticle() {
        selectedParticle = nil
        currentParticleNode?.removeFromParentNode()
        currentParticleNode = nil
    }
    
    func updateCurrentParticleNode(_ node: SCNNode) {
        if let currentBirthRate = currentBirthRate {
            node.particleSystems?.first?.birthRate = currentBirthRate
        }

        if let currentSpeedFactor = currentSpeedFactor {
            node.particleSystems?.first?.speedFactor = currentSpeedFactor
        }

        currentParticleNode = node
    }
}
