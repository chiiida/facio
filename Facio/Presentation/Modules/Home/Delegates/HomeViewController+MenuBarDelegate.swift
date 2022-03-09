//
//  HomeViewController+MenuBarDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import UIKit

extension HomeViewController: MenuBarDelegate {

    func didTapCameraButton() {
        let image = arView.snapshot()
        let previewVC = SnapshotPreviewViewController(image: image)
        let navVC = UINavigationController(rootViewController: previewVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }

    func didTapRecordButton(_ isRecording: Bool) {
        if isRecording {
            arRecoder.record()
        } else {
            arRecoder.stop { videoPath in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let previewVC = VideoPreviewViewController(videoPath: videoPath, arRecoder: self.arRecoder)
                    let navVC = UINavigationController(rootViewController: previewVC)
                    navVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(navVC, animated: true)
                }
            }
        }
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
