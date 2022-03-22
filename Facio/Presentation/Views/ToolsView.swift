//
//  ToolsView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 8/2/2565 BE.
//

import UIKit
import SceneKit

protocol ToolsViewDelegate: AnyObject {

    func didTapEditButton(_ node: SCNNode)
    func didTapRemoveButton(_ node: SCNNode)
    func didUpdatePositionZ(_ node: SCNNode, posZ: Float)
}

class ToolsView: UIView {

    private let stackView = UIStackView()
    private let editButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)
    private let sliderView = UIView()
    private let posZSliderView = SliderView(title: "Position Z", min: 1.0, max: 3.0, scale: 0.07)

    weak var delegate: ToolsViewDelegate?

    var node: SCNNode?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden,
               subview.isUserInteractionEnabled,
               subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    func hideEditButton(_ isHidden: Bool) {
        editButton.isHidden = isHidden
    }
    
    func hidePosZSlider(_ isHidden: Bool) {
        sliderView.isHidden = isHidden
    }
    
    func resetSlider() {
        posZSliderView.setCurrentValue(node?.position.z ?? 0.6)
    }

    private func setUpLayout() {
        self.addSubViews(
            stackView,
            sliderView
        )
        
        sliderView.addSubview(posZSliderView)

        stackView.addArrangedSubViews(
            editButton,
            removeButton
        )

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        sliderView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70.0)
        }
        
        posZSliderView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(35.0)
        }
    }

    private func setUpViews() {
        backgroundColor = .clear

        stackView.spacing = 18.0
        stackView.axis = .horizontal

        let font = UIFont.systemFont(ofSize: 18.0)
        let config = UIImage.SymbolConfiguration(font: font)
        
        editButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        editButton.tintColor = .white
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)

        removeButton.setImage(UIImage(systemName: "trash", withConfiguration: config), for: .normal)
        removeButton.imageView?.contentMode = .scaleAspectFill
        removeButton.tintColor = .white
        removeButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        removeButton.isUserInteractionEnabled = true
        
        sliderView.backgroundColor = .white.withAlphaComponent(0.6)
        
        posZSliderView.setCurrentValue(node?.position.z ?? 0.07)
        posZSliderView.valueFormal = .twoDecimal
        posZSliderView.isUserInteractionEnabled = true
        posZSliderView.delegate = self
    }

    @objc private func didTapEditButton() {
        guard let node = node else { return }
        delegate?.didTapEditButton(node)
    }

    @objc private func didTapRemoveButton() {
        guard let node = node else { return }
        delegate?.didTapRemoveButton(node)
    }
}

extension ToolsView: SliderViewDelegate {

    func sliderDidChange(tag: Int, value: Float) {
        guard let node = node else { return }
        delegate?.didUpdatePositionZ(node, posZ: value)
    }
}
