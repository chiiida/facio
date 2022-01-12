//
//  Double+DeviceSizeAdjusted.swift
//  Facio
//
//  Created by Chananchida Fuachai on 13/1/2565 BE.
//

extension Double {

    static var deviceAdjustedInset: Double {
        Device.hasTopNotch ? 0.0 : 12.0
    }

    private static var screenWith: Double = Double(Device.screenWidth)
    private static var screenHeight: Double = Double(Device.screenHeight)

    var deviceWidthAdjusted: Double { self * Double(Double.screenWith) / 375.0 }
    var deviceHeightAdjusted: Double { self * Double(Double.screenHeight) / 812.0 }

    var topSafeAreaAdjusted: Double {
        Device.hasTopNotch ? self : self + 12.0
    }

    var bottomSafeAreaAdjusted: Double {
        Device.hasTopNotch ? self : self + 12.0
    }
}
