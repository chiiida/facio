//
//  SnapshotPreviewViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 5/3/2565 BE.
//

import UIKit
import SnapKit

final class SnapshotPreviewViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let saveButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView()
    
    private var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpViews()
        setUpNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Private functions

extension SnapshotPreviewViewController {
    
    private func setUpLayout() {
        view.addSubViews(
            imageView,
            saveButton,
            shareButton,
            cancelButton
        )
        
        let imageScale = 1.0 / (image.size.width / image.size.height)
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(50.0.topSafeAreaAdjusted)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(imageView.snp.width).multipliedBy(imageScale)
        }
    }
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        imageView.image = image
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.titleLabel?.font = .regular(ofSize: .small)
        cancelButton.tintColor = .primaryGray
        
        saveButton.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        saveButton.tintColor = .primaryGray
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        saveButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .primaryGray
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        shareButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
    }
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton)
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: shareButton),
            UIBarButtonItem(customView: saveButton)
        ]
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapSaveButton() {
        UIImageWriteToSavedPhotosAlbum(image, showSavedIndicator(), nil, nil)
    }
    
    @objc private func didTapShareButton() {
        let shareText = "Checkout my picture from Facio!"
        let actionVC = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
        present(actionVC, animated: true, completion: nil)
    }
    
    private func showSavedIndicator() {
        let alertView = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertView.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .black.withAlphaComponent(0.5)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.alignment = .center

        let checkImageView = UIImageView()
        checkImageView.image = UIImage(systemName: "checkmark.circle")
        checkImageView.tintColor = .white
        
        let messageLabel = UILabel()
        messageLabel.text = "Saved"
        messageLabel.font = .regular(ofSize: .medium)
        messageLabel.textColor = .white
        
        stackView.addArrangedSubViews(
            checkImageView,
            messageLabel
        )
        alertView.view.addSubViews(
            stackView
        )
        checkImageView.snp.makeConstraints {
            $0.height.width.equalTo(60.0)
        }
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        alertView.view.snp.makeConstraints {
            $0.height.equalTo(150.0)
            $0.width.equalTo(150.0)
        }
        
        present(alertView, animated: true, completion: nil)
        UIView.animate(withDuration: 1.5) {
            alertView.dismiss(animated: true, completion: nil)
        }
    }
}
