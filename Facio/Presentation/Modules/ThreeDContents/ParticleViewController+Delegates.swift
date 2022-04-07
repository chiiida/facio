//
//  ParticleViewController+Delegates.swift
//  Facio
//
//  Created by Sirikonss on 1/4/2565 BE.
//

import UIKit
import Alderis

extension ParticleViewController: ParticleBarDelegate, ParticleSliderDelegate, ParticleSelectorDelegate {
    
    func didUpdateSpeed(value: Float) {
        birthRateValue = value * 10
        delegate?.didUpdateSpeed(speed: Float(speedValue))
    }
    
    func didUpdateBirthRate(value: Float) {
        speedValue = value * 10
        delegate?.didUpdateBirthRate(birthRate: Float(birthRateValue))
    }
    
    func didSelectParticle(_ particle: String) {
        currentParticle = particle
        showParticleSlider(particleMode: currentParticle)
        showParticleSelector(particleMode: currentParticle)
        particleSelector.colorButton.backgroundColor = .clear
        delegate?.didSelectParticle(particle: currentParticle)
    }

    func didTapSelectColor() {
        let colorPickerVC = ColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.configuration = ColorPickerConfiguration(color: .white)
        present(colorPickerVC, animated: true)
    }
}
