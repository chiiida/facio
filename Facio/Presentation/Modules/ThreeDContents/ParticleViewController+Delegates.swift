//
//  ParticleViewController+Delegates.swift
//  Facio
//
//  Created by Sirikonss on 1/4/2565 BE.
//

import UIKit

extension ParticleViewController: ParticleBarDelegate,ParticleSliderDelegate, ParticleSelectorDelegate {
    
    func didUpdateSpeed(value: Float) {
    
    }
    
    func didUpdateBirthRate(value: Float) {
        
    }
    
    
    func didSelectParticle(_ particle: String) {
        currentParticle = particle
        print(currentParticle)
        showParticleSlider(particleMode: currentParticle)
        showParticleSelector(particleMode: currentParticle)
    }
    
    func didTapImageButton() {
        let imagepickerVC = ImagePickerViewController()
        imagepickerVC.delegate = self
        present(imagepickerVC, animated: true, completion: nil)
    }

}
