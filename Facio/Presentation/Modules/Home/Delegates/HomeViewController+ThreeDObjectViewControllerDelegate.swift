//
//  HomeViewController+ThreeDObjectViewControllerDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 11/4/2565 BE.
//

extension HomeViewController: ThreeDObjectViewControllerDelegate {

    func didSelectThreeDObject(with type: ThreeDObjectType) {
        arView.addObject(with: type)
    }
}
