//
//  File.swift
//  Facio
//
//  Created by Sirikonss on 31/3/2565 BE.
//

import UIKit

protocol ParticleSelectorDelegate: AnyObject {
    
    func didTapImageButton()
    func didTapSelectColor()
}

class ParticleSelector: UIView {
    
    let imageButton = UIButton()
    let colorButton = UIButton()
    
    weak var delegate: ParticleSelectorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLayoutSubviews() {
        
        colorButton.layer.backgroundColor = UIColor(ciColor: .white).cgColor
        colorButton.layer.cornerRadius = colorButton.bounds.size.width / 2
        colorButton.layer.borderColor = UIColor(ciColor: .gray).cgColor
        colorButton.layer.borderWidth = 1
        
    }
    
    private func setUpLayout() {
        self.addSubViews(
            imageButton,
            colorButton
        )
    }
    
    private func setUpViews() {
        self.backgroundColor = .clear
        
        imageButton.snp.makeConstraints {
            $0.height.equalTo(50.0)
            $0.width.equalTo(50.0)
            $0.centerX.equalToSuperview().offset(-10)
            $0.top.equalTo(20)
        }
        
        colorButton.snp.makeConstraints {
            $0.height.equalTo(25.0)
            $0.width.equalTo(25.0)
            $0.centerX.equalToSuperview().offset(40)
            $0.centerY.equalTo(imageButton)
            $0.top.equalTo(20)
        }
        
        imageButton.setImage(Asset.mainMenu.imageIcon(), for: .normal)
        imageButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        imageButton.tintColor = .primaryGray
        imageButton.addTarget(self, action: #selector(didTapImageButton), for: .touchUpInside)
        
        colorButton.addTarget(self, action: #selector(didTapSelectColor), for: .touchUpInside)
        
    }
    
    @objc private func didTapImageButton() {
        delegate?.didTapImageButton()
        
    }
    
    @objc private func didTapSelectColor() {
        delegate?.didTapSelectColor()
        
    }
}
