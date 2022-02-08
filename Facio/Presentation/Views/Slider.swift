//
//  Slider.swift
//  Facio
//
//  Created by Chananchida Fuachai on 2/2/2565 BE.
//

import UIKit

class Slider: UISlider {

    var trackHeight: CGFloat = 2.0
    var thumbRadius: CGFloat = 15.0

    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .primaryGray
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = UIColor.primaryGray.cgColor
        return thumb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func thumbImage(radius: CGFloat) -> UIImage {
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2

        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}
