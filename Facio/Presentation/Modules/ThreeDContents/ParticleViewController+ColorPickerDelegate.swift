//
//  ParticleViewController+ColorPickerDelegate.swift
//  Facio
//
//  Created by Sirikonss on 1/4/2565 BE.
//

import UIKit
import Alderis

extension ParticleViewController: ColorPickerDelegate {
    
    @objc(colorPicker:didSelectColor:)
    func colorPicker(_ colorPicker: ColorPickerViewController, didSelect selectedColor: UIColor) {
        particleSelector.colorButton.backgroundColor = selectedColor
        delegate?.didSelectColor(color: selectedColor)
    }
    
    @objc(colorPicker:didAcceptColor:)
    func colorPicker(_ colorPicker: ColorPickerViewController, didAccept selectedColor: UIColor) {
        particleSelector.colorButton.backgroundColor = selectedColor
        delegate?.didSelectColor(color: selectedColor)
    }
}
