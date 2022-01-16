//
//  UIFont+Size.swift
//  Facio
//
//  Created by Chananchida Fuachai on 13/1/2565 BE.
//

import UIKit

public extension UIFont {

    enum FontSize: CGFloat {

        case regular = 18.0
        case medium = 16.0
        case small = 14.0
        case xxSmall = 12.0
    }

    enum FontFamily {

        case comfortaa
        case openSans


        func bold(ofSize size: FontSize) -> UIFont {
            var font: UIFont?
            switch self {
            case .comfortaa:
                font = Font.comfortaaBold(size: size.rawValue)
            case .openSans:
                font = Font.openSansBold(size: size.rawValue)
            }
            return font ?? .boldSystemFont(ofSize: size.rawValue)
        }

        func semiBold(ofSize size: FontSize) -> UIFont {
            var font: UIFont?
            switch self {
            case .comfortaa:
                font = Font.comfortaaSemiBold(size: size.rawValue)
            case .openSans:
                font = Font.openSansSemiBold(size: size.rawValue)
            }
            return font ?? .systemFont(ofSize: size.rawValue, weight: .semibold)
        }

        func regular(ofSize size: FontSize) -> UIFont {
            var font: UIFont?
            switch self {
            case .comfortaa:
                font = Font.comfortaaMedium(size: size.rawValue)
            case .openSans:
                font = Font.openSansRegular(size: size.rawValue)
            }
            return font ?? .systemFont(ofSize: size.rawValue)
        }
    }

    /**weight = 400*/
    static func regular(_ font: FontFamily = FontFamily.openSans, ofSize size: FontSize) -> UIFont {
        font.regular(ofSize: size)
    }

    /**weight = 600*/
    static func semiBold(_ font: FontFamily = FontFamily.openSans, ofSize size: FontSize) -> UIFont {
        font.semiBold(ofSize: size)
    }

    /**weight = 700*/
    static func bold(_ font: FontFamily = FontFamily.openSans, ofSize size: FontSize) -> UIFont {
        font.bold(ofSize: size)
    }
}
