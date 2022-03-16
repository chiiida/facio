//
//  HomeViewController+MenuBarDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import UIKit

extension HomeViewController: MenuBarDelegate {

    func didTapCameraButton(state: MenuBar.CameraMode) {
        // TODO: implement in integration
    }

    func didTapRecordButton() {
        // TODO: implement in integration
    }

    func didTapImageButton() {
        let imagepickerVC = ImagePickerViewController()
        imagepickerVC.delegate = self
        present(imagepickerVC, animated: true, completion: nil)
    }

    func didTapDrawButton() {
        let drawingBoardVC = DrawingBoardViewController()
        drawingBoardVC.delegate = self
        let navVC = UINavigationController(rootViewController: drawingBoardVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }

    func didTapTextButton() {
        let textEditorVC = TextEditorViewController()
        textEditorVC.delegate = self
        let navVC = UINavigationController(rootViewController: textEditorVC)
        navVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(navVC, animated: true)
    }

    func didTapBeautificationButton() {
        // TODO: implement in integration
    }
}
