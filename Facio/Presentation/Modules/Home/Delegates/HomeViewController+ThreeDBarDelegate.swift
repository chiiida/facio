//
//  HomeViewController+ThreeDBarDelegate.swift
//  Facio
//
//  Created by Sirikonss on 29/3/2565 BE.
//

import UIKit

extension HomeViewController: ThreeDBarDelegate {
    
    func didTapParticleButton() {
        let particleVC = ParticleViewController()
        particleVC.delegate = self
        let navVC = UINavigationController(rootViewController: particleVC)
        navVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    func didTapObjectsButton() {
        // To implement
    }
}
  
extension HomeViewController: ParticleDelegate {
    func didTapDoneButton() {
        
    }
}
