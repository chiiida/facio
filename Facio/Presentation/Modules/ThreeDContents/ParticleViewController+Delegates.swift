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
        delegate?.didSelectParticle(
            particle: currentParticle,
            birthRate: Float(birthRateValue),
            speed: Float(speedValue))
    }
    
    func didUpdateBirthRate(value: Float) {
        speedValue = value * 10
        delegate?.didSelectParticle(
            particle: currentParticle,
            birthRate: Float(birthRateValue),
            speed: Float(speedValue))
    }
    
    func didSelectParticle(_ particle: String) {
        currentParticle = particle
        showParticleSlider(particleMode: currentParticle)
        showParticleSelector(particleMode: currentParticle)
        delegate?.didSelectParticle(
            particle: currentParticle,
            birthRate: Float(birthRateValue),
            speed: Float(speedValue))
    }
    
    func didTapImageButton() {
        let imagepickerVC = ImagePickerViewController()
        imagepickerVC.delegate = self
        present(imagepickerVC, animated: true, completion: nil)
    }

    func didTapSelectColor() {
        let colorPickerVC = ColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.configuration = ColorPickerConfiguration(color: .white)
        present(colorPickerVC, animated: true)
    }
}
