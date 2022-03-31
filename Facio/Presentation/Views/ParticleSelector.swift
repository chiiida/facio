//
//  File.swift
//  Facio
//
//  Created by Sirikonss on 31/3/2565 BE.
//

import UIKit

protocol ParticleSelectorDelegate: AnyObject {
    
    func didTapImageButton()
}

class ParticleSelector: UIView {
    
    private let imageButton = UIButton()
    
    weak var delegate: ParticleSelectorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        self.addSubViews(
            imageButton
        )
    }
    
    private func setUpViews() {
        self.backgroundColor = .clear
        
        imageButton.snp.makeConstraints {
            $0.height.equalTo(50.0)
            $0.width.equalTo(50.0)
            $0.centerX.equalToSuperview().offset(-10)
            $0.top.equalTo(10)
        }
        imageButton.setImage(Asset.mainMenu.imageIcon(), for: .normal)
        imageButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        imageButton.tintColor = .primaryGray
        imageButton.addTarget(self, action: #selector(didTapImageButton), for: .touchUpInside)
    }
    
    @objc private func didTapImageButton() {
        delegate?.didTapImageButton()
        
    }
}

