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
}

class ToolsView: UIView {

    private let stackView = UIStackView()
    private let editButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)

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

    private func setUpLayout() {
        self.addSubview(stackView)

        stackView.addArrangedSubViews(
            editButton,
            removeButton
        )

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }

        stackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.height.width.equalTo(30.0)
            }
        }
    }

    private func setUpViews() {
        backgroundColor = .clear

        stackView.spacing = 20.0
        stackView.axis = .horizontal

        editButton.setImage(Asset.tools.editor(), for: .normal)
        editButton.tintColor = .white
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)

        removeButton.setImage(Asset.tools.delete(), for: .normal)
        removeButton.tintColor = .white
        removeButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        removeButton.isUserInteractionEnabled = true
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
