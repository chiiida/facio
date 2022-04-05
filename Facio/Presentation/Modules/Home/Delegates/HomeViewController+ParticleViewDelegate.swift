//
//  HomeViewController+ParticleViewDelegate.swift
//  Facio
//
//  Created by Sirikonss on 5/4/2565 BE.
//

import UIKit

extension HomeViewController: ParticleDelegate {
    
    func didSelectParticle(particle: String, birthRate: Float, speed: Float) {
        if particle == "Bokeh" {
            arView.addParticle(Particle.bokeh, birthRate: CGFloat(birthRate), speed: CGFloat(speed))
        } else if particle == "Confetti" {
            arView.addParticle(Particle.confetti, birthRate: CGFloat(birthRate), speed: CGFloat(speed))
        } else if particle == "Stars" {
            arView.addParticle(Particle.stars, birthRate: CGFloat(birthRate), speed: CGFloat(speed))
        } else if particle == "Rain" {
            arView.addParticle(Particle.rain, birthRate: CGFloat(birthRate), speed: CGFloat(speed))
        } else {
            arView.removeParticle()
        }
    }
    
}
