//
//  HomeViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 27/9/2564 BE.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let helloLabel = UILabel()
        helloLabel.text = "Hello"
        helloLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(helloLabel)

        helloLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
