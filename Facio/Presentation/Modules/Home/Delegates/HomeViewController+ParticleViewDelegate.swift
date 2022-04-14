//
//  HomeViewController+ParticleViewDelegate.swift
//  Facio
//
//  Created by Sirikonss on 5/4/2565 BE.
//

import UIKit

extension HomeViewController: ParticleDelegate {
    
    func didSelectColor(color: UIColor) {
        arView.colorParticle(color: color)
    }
    
    func didUpdateBirthRate(birthRate: Float) {
        arView.updateBirthRate(birthRate: CGFloat(birthRate))
    }
    
    func didUpdateSpeed(speed: Float) {
        arView.updateSpeed(speed: CGFloat(speed))
    }
    
    func didSelectParticle(particle: String) {
        if particle == "Bokeh" {
            arView.addParticle(Particle.bokeh)
        } else if particle == "Confetti" {
            arView.addParticle(Particle.confetti)
        } else if particle == "Stars" {
            arView.addParticle(Particle.stars)
        } else if particle == "Rain" {
            arView.addParticle(Particle.rain)
        } else {
            arView.removeParticle()
        }
    }
}
