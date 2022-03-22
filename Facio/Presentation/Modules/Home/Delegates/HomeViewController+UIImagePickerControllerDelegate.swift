//
//  HomeViewController+UIImagePickerControllerDelegate.swift
//  Facio
//
//  Created by Chananchida Fuachai on 15/2/2565 BE.
//

import UIKit

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func fixOrientation(img: UIImage) -> UIImage {
        if img.imageOrientation == .up {
            return img
        }

        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)

        guard let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        else { return img }
        UIGraphicsEndImageContext()

        return normalizedImage
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        let imageToDisplay = fixOrientation(img: pickedImage)
        let faceNode = FaceNode(at: FeatureIndices.nose)
        let timestamp = Date().timeIntervalSince1970
        let imageNodeName = "image\(timestamp)"
        faceNode.name = imageNodeName
        let viewModel = FaceNodeViewModel(node: faceNode)
        viewModel.addImage(imageToDisplay)
        arView.addNode(from: viewModel)
        dismiss(animated: true, completion: nil)
    }
}
