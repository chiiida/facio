//
//  HomeViewController+MaterialMenuViewDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import UIKit
import ARKit

extension HomeViewController: MaterialMenuViewDelegate {

    func didUpdateMaterial(type: MaterialMenuView.MaterialType, value: Float) {
        let material = SCNMaterial()
        switch type {
        case .metalness: material.metalness.contents = value
        case .roughness: material.roughness.contents = value
        case .shininess: material.shininess = CGFloat(value)
        }
        arView.updateFaceMask(with: material)
    }
}
