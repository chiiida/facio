//
//  SliderView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 2/2/2565 BE.
//

import UIKit
import SnapKit

protocol SliderViewDelegate: AnyObject {

    func sliderDidChange(tag: Int, value: Float)
}

class SliderView: UIView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let slider = Slider()

    private var scale: Float

    weak var delegate: SliderViewDelegate?

    init(title: String, min: Float, max: Float, scale: Float = 0.1) {
        self.scale = scale
        super.init(frame: .zero)
        setUpLayout()
        setUpViews(title: title, min: min, max: max)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCurrentValue(_ value: Float) {
        valueLabel.text = String(format: "%.0f", value)
        slider.setValue(value, animated: true)
    }

    func setSliderTag(_ tag: Int) {
        slider.tag = tag
    }

    private func setUpLayout() {
        self.addSubViews(
            titleLabel,
            valueLabel,
            slider
        )

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        valueLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }

        slider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3.0)
            $0.top.equalTo(valueLabel.snp.bottom).offset(3.0)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func setUpViews(title: String, min: Float, max: Float) {
        valueLabel.font = .regular(ofSize: .xxSmall)
        valueLabel.textColor = .primaryGray

        titleLabel.font = .regular(ofSize: .xxSmall)
        titleLabel.textColor = .primaryGray
        titleLabel.text = title

        slider.minimumValue = min
        slider.maximumValue = max
        slider.isContinuous = true
        slider.tintColor = .primaryGray
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
    }

    @objc private func sliderValueDidChange(_ sender: UISlider) {
        valueLabel.text = String(format: "%.0f", sender.value)
        delegate?.sliderDidChange(tag: sender.tag, value: sender.value * scale)
    }
}
