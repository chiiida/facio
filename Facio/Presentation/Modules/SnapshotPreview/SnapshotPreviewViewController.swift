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
    
    private var image: UIImage?
    
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
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(20.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(50.0.bottomSafeAreaAdjusted)
        }
    }
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        imageView.image = image
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
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
        guard let image = image else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    @objc private func didTapShareButton() {
        guard let image = image else { return }
        let shareText = "Checkout my picture!"
        let actionVC = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
        present(actionVC, animated: true, completion: nil)
    }
}
