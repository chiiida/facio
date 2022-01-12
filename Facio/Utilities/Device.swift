//
//  Device.swift
//  Facio
//
//  Created by Chananchida Fuachai on 13/1/2565 BE.
//

import UIKit

enum Device {

    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height

    static var topSafeAreaInset: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
        } else {
            return UIApplication.shared.keyWindow?.rootViewController?.topLayoutGuide.length ?? 0.0
        }
    }

    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }

    static var bottomSafeAreaInset: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        } else {
            return UIApplication.shared.keyWindow?.rootViewController?.bottomLayoutGuide.length ?? 0.0
        }
    }
}
