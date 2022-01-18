//
//  ImagePickerViewController.swift
//  Facio
//
//  Created by Sirikonss on 16/1/2565 BE.
//

import UIKit

final class ImagePickerViewController: UIImagePickerController {
    
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
    }
    
}
