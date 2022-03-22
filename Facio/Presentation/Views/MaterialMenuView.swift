//
//  MaterialMenuView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 2/2/2565 BE.
//

import UIKit

protocol MaterialMenuViewDelegate: AnyObject {

    func didUpdateMaterial(type: MaterialMenuView.MaterialType, value: Float)
}

class MaterialMenuView: UIView {

    private let sliderStackView = UIStackView()
    private let metalnessSliderView = SliderView(title: MaterialType.metalness.title, min: 0.0, max: 15.0)
    private let roughnessSliderView = SliderView(title: MaterialType.roughness.title, min: 0.0, max: 15.0)
    private let shininessSliderView = SliderView(title: MaterialType.shininess.title, min: 0.0, max: 100.0, scale: 1)

    weak var delegate: MaterialMenuViewDelegate?

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
            metalnessSliderView,
            roughnessSliderView,
            shininessSliderView
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
        sliderStackView.isHidden = true

        metalnessSliderView.setCurrentValue(1.0)
        metalnessSliderView.setSliderTag(MaterialType.metalness.tag)
        metalnessSliderView.isUserInteractionEnabled = true
        metalnessSliderView.delegate = self

        roughnessSliderView.setCurrentValue(1.0)
        roughnessSliderView.setSliderTag(MaterialType.roughness.tag)
        roughnessSliderView.isUserInteractionEnabled = true
        roughnessSliderView.delegate = self

        shininessSliderView.setCurrentValue(1.0)
        shininessSliderView.setSliderTag(MaterialType.shininess.tag)
        shininessSliderView.isUserInteractionEnabled = true
        shininessSliderView.delegate = self
    }

    func hide(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .transitionCurlDown,
                animations: {
                    completion()
                    self?.alpha = 0.0
                    self?.sliderStackView.isHidden = true
                    self?.layoutIfNeeded()
                }
            )
            self?.isHidden = true
        }
    }

    func show(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .transitionCurlUp,
                animations: {
                    self?.isHidden = false
                    completion()
                    self?.sliderStackView.isHidden = false
                    self?.alpha = 1.0
                    self?.layoutIfNeeded()
                }
            )
        }
    }

    func resetValue() {
        metalnessSliderView.setCurrentValue(1.0)
        roughnessSliderView.setCurrentValue(1.0)
        shininessSliderView.setCurrentValue(1.0)
    }
}

extension MaterialMenuView {

    enum MaterialType {

        case metalness
        case roughness
        case shininess

        var title: String {
            switch self {
            case .metalness: return "Metalness"
            case .roughness: return "Roughness"
            case .shininess: return "Shininess"
            }
        }

        var tag: Int {
            switch self {
            case .metalness: return 0
            case .roughness: return 1
            case .shininess: return 2
            }
        }
    }
}

extension MaterialMenuView: SliderViewDelegate {

    func sliderDidChange(tag: Int, value: Float) {
        if tag == MaterialType.metalness.tag {
            delegate?.didUpdateMaterial(type: .metalness, value: value)
        } else if tag == MaterialType.roughness.tag {
            delegate?.didUpdateMaterial(type: .roughness, value: value)
        } else {
            delegate?.didUpdateMaterial(type: .shininess, value: value)
        }
    }
}
