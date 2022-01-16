//
//  UIView+SubView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 13/1/2565 BE.
//

import UIKit

extension UIView {

    func addSubViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    func removeAllSubViews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

extension UIStackView {

    func addArrangedSubViews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
