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
    
<<<<<<< HEAD
    
=======
>>>>>>> b876e1d4e478f21718afc44a1b76f090ef30db91
}

extension ParticleViewController {
    
    private func setUpLayout() {
        view.addSubViews(
            particleBar,
            doneButton,
<<<<<<< HEAD
            particleSlider,
            particleSelector
=======
            particleSlider
>>>>>>> b876e1d4e478f21718afc44a1b76f090ef30db91
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
        
<<<<<<< HEAD
        particleBar.delegate = self
=======
>>>>>>> b876e1d4e478f21718afc44a1b76f090ef30db91
        particleBar.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
<<<<<<< HEAD
        particleSlider.delegate = self
=======
>>>>>>> b876e1d4e478f21718afc44a1b76f090ef30db91
        particleSlider.isHidden = true
        particleSlider.snp.makeConstraints {
            $0.height.equalTo(120.0)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(particleBar.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
<<<<<<< HEAD
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
=======
        showParticleSlider()
>>>>>>> b876e1d4e478f21718afc44a1b76f090ef30db91
    }
       
    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: doneButton)
        ]
    }
    
<<<<<<< HEAD
    func showParticleSlider(particleMode: String) {
        if particleMode == "None" {
            particleSlider.isHidden = true
        } else {
=======
    private func showParticleSlider() {
        if currentParticle != "None" {
>>>>>>> b876e1d4e478f21718afc44a1b76f090ef30db91
            particleSlider.isHidden = false
        }
    }
    
<<<<<<< HEAD
    func showParticleSelector(particleMode: String) {
        
        if particleMode == "None" {
            particleSelector.isHidden = true
        } else {
            particleSelector.isHidden = false
        }
    }
    
=======
>>>>>>> b876e1d4e478f21718afc44a1b76f090ef30db91
    @objc internal func didTapDoneButton() {
        delegate?.didTapDoneButton()
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
}

<<<<<<< HEAD

=======
extension ParticleViewController: ParticleBarDelegate {
    
    func didSelectParticle(_ particle: String) {
        currentParticle = particle
        
    }

}
>>>>>>> b876e1d4e478f21718afc44a1b76f090ef30db91
