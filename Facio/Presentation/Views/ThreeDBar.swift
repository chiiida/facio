//
//  threeDBar.swift
//  Facio
//
//  Created by Sirikonss on 25/3/2565 BE.
//

import UIKit

class ThreeDBar: UIView {
    
    private let particleLabel = UILabel()
    private let particleButton = UIButton()
    private let objectsLabel = UILabel()
    private let objectsButton = UIButton()
    
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
            particleButton,
            particleLabel,
            objectsButton,
            objectsLabel
        )
        
        setUpButtons()
    }
    
    private func setUpButtons() {
        particleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-50)
            $0.centerY.equalToSuperview().offset(-20)
        }
        
        particleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-50)
            $0.centerY.equalToSuperview().offset(20)
        }
        
        objectsButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(50)
            $0.centerY.equalTo(particleButton)
            $0.height.width.equalTo(35.0)
        }
        
        objectsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(50)
            $0.centerY.equalTo(particleLabel)
        }
    }
    private func setUpViews() {
        self.backgroundColor = .white
        
        particleLabel.text = "Particle"
        particleLabel.font = .regular(.comfortaa, ofSize: .xxSmall)
        particleLabel.textColor = .primaryGray
        
        objectsLabel.text = "Objects"
        objectsLabel.font = .regular(.comfortaa, ofSize: .xxSmall)
        objectsLabel.textColor = .primaryGray
        
        particleButton.setImage(Asset.mainMenu.particleIcon(), for: .normal)
        particleButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        particleButton.addTarget(self, action: #selector(didTapParticleButton), for: .touchUpInside)

        objectsButton.setImage(Asset.mainMenu.objectsIcon(), for: .normal)
        objectsButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        objectsButton.addTarget(self, action: #selector(didTapObjectsButton), for: .touchUpInside)
    }
        
    @objc private func didTapParticleButton() {
        
    }
    
    @objc private func didTapObjectsButton() {
        
    }
}
