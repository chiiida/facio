//
//  ParticleViewController.swift
//  Facio
//
//  Created by Sirikonss on 29/3/2565 BE.
//

import UIKit

protocol ParticleDelegate: AnyObject {
    
    func didTapDoneButton()

}

final class ParticleViewController: UIViewController {
    
    private let particleSlider = ParticleSlider()
    private let particleSelector = ParticleSelector()
    private let particleBar = ParticleBar()
    
    var currentParticle = "None"
    private let doneButton = UIButton(type: .system)
    
    weak var delegate: ParticleDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        particleBar.loadLayoutSubviews()
    }
    
    
}

extension ParticleViewController {
    
    private func setUpLayout() {
        view.addSubViews(
            particleBar,
            doneButton,
            particleSlider,
            particleSelector
        )
        
        setUpNavigationBar()
    }
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.titleLabel?.font = .regular(ofSize: .small)
        doneButton.tintColor = .primaryGray
        
        particleBar.delegate = self
        particleBar.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        particleSlider.delegate = self
        particleSlider.isHidden = true
        particleSlider.snp.makeConstraints {
            $0.height.equalTo(120.0)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(particleBar.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        particleSelector.delegate = self
        particleSelector.isHidden = true
        particleSelector.snp.makeConstraints {
            $0.height.equalTo(55.0)
            $0.width.equalToSuperview()
            $0.top.equalTo(particleBar.snp.top)
            $0.leading.trailing.equalToSuperview()

        }
        
        showParticleSlider(particleMode: currentParticle)
        showParticleSelector(particleMode: currentParticle)
    }
       
    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: doneButton)
        ]
    }
    
    func showParticleSlider(particleMode: String) {
        if particleMode == "None" {
            particleSlider.isHidden = true
        } else {
            particleSlider.isHidden = false
        }
    }
    
    func showParticleSelector(particleMode: String) {
        
        if particleMode == "None" {
            particleSelector.isHidden = true
        } else {
            particleSelector.isHidden = false
        }
    }
    
    @objc internal func didTapDoneButton() {
        delegate?.didTapDoneButton()
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
}


