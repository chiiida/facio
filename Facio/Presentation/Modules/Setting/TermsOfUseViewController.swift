//
//  TermsOfUseViewController.swift
//  Facio
//
//  Created by Sirikonss on 24/3/2565 BE.
//

import UIKit

final class TermsOfUseViewController: UIViewController {
    
    private let cancelButton = UIButton(type: .system)
    private let details = UITextView()
    
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
}

extension TermsOfUseViewController {
    
    private func setUpLayout() {
        view.addSubViews(
            details
        )
    }
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = false
        view.backgroundColor = .white
        
        details.frame = CGRect(x: 100, y: 100, width: 350, height: 700)
        details.center = self.view.center
        details.textColor = .primaryGray
        details.font = UIFont.systemFont(ofSize: 14)
        details.textAlignment = .justified
        
        loadTerms()
        setUpNavigationBar()
    }
    
    private func loadTerms() {
        if let filepath = Bundle.main.path(forResource: "TermsOfUse", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                details.text = contents
            } catch {}
        } else {
            print("file not found")
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "Terms of Use"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton)
        ]
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.titleLabel?.font = .regular(ofSize: .small)
        cancelButton.tintColor = .primaryGray
        
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}


