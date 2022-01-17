//
//  ImagePickerViewController.swift
//  Facio
//
//  Created by Sirikonss on 16/1/2565 BE.
//

import UIKit

final class ImagePickerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private let imagePicker = UIImagePickerController()
    private let cancelButton = UIButton(type: .system)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
            super.viewDidLoad()
//            setUpLayout()
            setUpViews()
        }
}

extension ImagePickerViewController {
    
    private func setUpLayout() {
//        view.addSubview(
//            imagePicker
//        )

    }
    
    private func setUpViews() {
        
        navigationController?.navigationItem.hidesBackButton = true
        view.backgroundColor = .lightGray

        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
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
