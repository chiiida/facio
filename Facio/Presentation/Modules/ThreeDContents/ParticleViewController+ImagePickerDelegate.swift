//
//  ParticleViewController+ImagePickerDelegate.swift
//  Facio
//
//  Created by Sirikonss on 1/4/2565 BE.
//

import UIKit

extension ParticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    }
}


