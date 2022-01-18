//
//  UIColor+Application.swift
//  Facio
//
//  Created by Chananchida Fuachai on 13/1/2565 BE.
//

import UIKit

// MARK: - Static color

extension UIColor {

    /// #434753
    static var primaryGray: UIColor { UIColor(hex: 0x434753) }

    /// #F5F5F5
    static var lightGray: UIColor { UIColor(hex: 0xF5F5F5) }

    /// #696969
    static var darkGray: UIColor { UIColor(hex: 0x696969) }
}

// MARK: - Convenience init

extension UIColor {

    private convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
