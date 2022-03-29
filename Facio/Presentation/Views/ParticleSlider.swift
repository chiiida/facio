//
//  Particle Slider.swift
//  Facio
//
//  Created by Sirikonss on 30/3/2565 BE.
//

import UIKit

protocol ParticleSliderDelegate: AnyObject {
    
    func didUpdateSpeed(value: Float)
    func didUpdateBirthRate(value: Float)
}

class ParticleSlider: UIView {
    
    private let sliderStackView = UIStackView()
    private let speedSliderView = SliderView(title: "Speed", min: 1.0, max: 100.0)
    private let birthRateSiderView = SliderView(title: "Birth rate", min: 1.0, max: 100.0)
    
    weak var delegate: ParticleSliderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        setUpViews()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpLayout() {
        self.addSubViews(sliderStackView)

        sliderStackView.addArrangedSubViews(
            speedSliderView,
            birthRateSiderView
        )
        
        sliderStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(35.0)
        }
    }
    
    private func setUpViews() {
        backgroundColor = .white.withAlphaComponent(0.6)

        sliderStackView.axis = .vertical
        sliderStackView.spacing = 12.0
        sliderStackView.isHidden = false

        speedSliderView.setCurrentValue(1.0)
        speedSliderView.setSliderTag(0)
        speedSliderView.isUserInteractionEnabled = true
        speedSliderView.delegate = self

        birthRateSiderView.setCurrentValue(1.0)
        birthRateSiderView.setSliderTag(1)
        birthRateSiderView.isUserInteractionEnabled = true
        birthRateSiderView.delegate = self
    }

    func resetValue() {
        speedSliderView.setCurrentValue(1.0)
        birthRateSiderView.setCurrentValue(1.0)
    }
}

extension ParticleSlider: SliderViewDelegate {

    func sliderDidChange(tag: Int, value: Float) {
        if tag == 0 {
            delegate?.didUpdateSpeed(value: value)
        } else if tag == 1 {
            delegate?.didUpdateBirthRate(value: value)
        }
    }
}
