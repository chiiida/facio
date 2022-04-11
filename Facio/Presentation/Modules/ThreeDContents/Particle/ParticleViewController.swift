//
//  ParticleViewController.swift
//  Facio
//
//  Created by Sirikonss on 29/3/2565 BE.
//

import UIKit

protocol ParticleDelegate: AnyObject {
    
    func didSelectParticle(particle: String)
    func didSelectColor(color: UIColor)
    func didUpdateBirthRate(birthRate: Float)
    func didUpdateSpeed(speed: Float)
    
}

final class ParticleViewController: UIViewController {
    
    var currentParticle = "None"
    var birthRateValue: Float = 10.0
    var speedValue: Float = 10.0
    
    let particleSlider = ParticleSlider()
    let particleSelector = ParticleSelector()
    let particleBar = ParticleBar()
    
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
        particleSelector.loadLayoutSubviews()
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
        doneButton.tintColor = .white
        
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
            particleSlider.resetValue()
            particleSlider.isHidden = false
        }
    }
    
    func showParticleSelector(particleMode: String) {
        
        if particleMode == "Bokeh" || particleMode == "Stars" {
            particleSelector.isHidden = false
        } else {
            particleSelector.isHidden = true
        }
    }
    
    @objc internal func didTapDoneButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
