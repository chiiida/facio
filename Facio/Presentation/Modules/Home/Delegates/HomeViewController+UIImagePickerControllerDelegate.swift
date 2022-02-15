//
//  HomeViewController+UIImagePickerControllerDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import UIKit

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        let faceNode = FaceNode(at: FeatureIndices.nose)
        let timestamp = Date().timeIntervalSince1970
        let imageNodeName = "image\(timestamp)"
        faceNode.name = imageNodeName
        let viewModel = FaceNodeViewModel(node: faceNode)
        viewModel.addImage(pickedImage)
        arView.addNode(from: viewModel)
        dismiss(animated: true, completion: nil)
    }
}
