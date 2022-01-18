//
//  ImagePickerViewController.swift
//  Facio
//
//  Created by Sirikonss on 16/1/2565 BE.
//

import UIKit

final class ImagePickerViewController: UIImagePickerController {

    private let cancelButton = UIButton(type: .system)
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setUpViews()
        }
}

extension ImagePickerViewController {
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = true
        sourceType = .photoLibrary
        allowsEditing = true
        setUpHeader()
        setUpNavigationBar()
       }
    
    private func setUpHeader() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton)
        ]
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
