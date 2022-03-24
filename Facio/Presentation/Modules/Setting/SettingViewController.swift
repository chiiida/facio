//
//  SettingViewController.swift
//  Facio
//
//  Created by Sirikonss on 23/3/2565 BE.
//

import UIKit


final class SettingViewController: UIViewController {
    
    private let cancelButton = UIButton(type: .system)
    private let privacy = UIButton(type: .custom)
    private let terms = UIButton(type: .custom)
    private let aboutUs = UIButton(type: .custom)
    private let version = UIButton(type: .custom)
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        version.setBackgroundImage(Asset.setting.facioVersion(), for: .normal)
        let buttons = [privacy, terms, aboutUs]
        buttons.forEach {
            $0.layer.borderColor = UIColor.systemGray5.cgColor
            $0.layer.borderWidth = 1
        }
    }
}

extension SettingViewController {
    
    private func setUpLayout() {
        view.addSubViews(
            privacy,
            terms,
            aboutUs,
            version
        )
        
    }
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = false
        view.backgroundColor = .white
        
        setUpNavigationBar()
        setUpButtons()
        
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton)
        ]
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.titleLabel?.font = .regular(ofSize: .small)
        cancelButton.tintColor = .primaryGray
        
    }
    
    private func setUpButtons() {
        privacy.setTitle("Privacy Policy", for: .normal)
        terms.setTitle("Terms of Use", for: .normal)
        aboutUs.setTitle("About us", for: .normal)
        
        privacy.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
        terms.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        aboutUs.addTarget(self, action: #selector(didTapAboutUs), for: .touchUpInside)
        
        setUpButtonStyle()
    }
    
    private func setUpButtonStyle() {
        
        let buttons = [privacy, terms, aboutUs]
        buttons.forEach {
            $0.setTitleColor(.primaryGray, for: .normal)
            $0.titleLabel?.font = .regular(ofSize: .small)
            $0.tintColor = .primaryGray
            $0.contentHorizontalAlignment = .left
            $0.titleEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        }
        
        privacy.snp.makeConstraints {
            $0.width.equalTo(400.0)
            $0.height.equalTo(70.0)
            $0.top.equalToSuperview().inset(50.0)
            $0.leading.equalToSuperview().inset(0.0)
        }
        terms.snp.makeConstraints {
            $0.width.equalTo(400.0)
            $0.height.equalTo(70.0)
            $0.top.equalToSuperview().inset(119.0)
            $0.leading.equalToSuperview().inset(0.0)
        }
        aboutUs.snp.makeConstraints {
            $0.width.equalTo(400.0)
            $0.height.equalTo(70.0)
            $0.top.equalToSuperview().inset(188.0)
            $0.leading.equalToSuperview().inset(0.0)
        }
        version.snp.makeConstraints {
            $0.width.equalTo(129.0)
            $0.height.equalTo(66.0)
            $0.top.equalToSuperview().inset(320.0)
            $0.leading.trailing.equalToSuperview().inset(120.0)
        }
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapPrivacy() {
        let privacyVC = PrivacyViewController()
        let navVC = UINavigationController(rootViewController: privacyVC)
        navVC.modalPresentationStyle = .currentContext
        navigationController?.present(navVC, animated: true)
    }
    
    @objc private func didTapTerms() {
        let privacyVC = TermsOfUseViewController()
        let navVC = UINavigationController(rootViewController: privacyVC)
        navVC.modalPresentationStyle = .currentContext
        navigationController?.present(navVC, animated: true)
    }
    
    @objc private func didTapAboutUs() {
        let privacyVC = AboutUsViewController()
        let navVC = UINavigationController(rootViewController: privacyVC)
        navVC.modalPresentationStyle = .currentContext
        navigationController?.present(navVC, animated: true)
    }
}
