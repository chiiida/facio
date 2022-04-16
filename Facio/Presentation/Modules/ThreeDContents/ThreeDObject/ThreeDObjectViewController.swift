//
//  ThreeDObjectViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 11/4/2565 BE.
//

import UIKit

protocol ThreeDObjectViewControllerDelegate: AnyObject {

    func didSelectThreeDObject(with type: ThreeDObjectType)
}

final class ThreeDObjectViewController: UIViewController {

    private let threeDObjBar = ThreeDObjectBar()
    private let doneButton = UIButton(type: .system)

    private var currentThreeDObj: ThreeDObjectType = .none

    weak var delegate: ThreeDObjectViewControllerDelegate?

    init(currentThreeDObj: ThreeDObjectType) {
        super.init(nibName: nil, bundle: nil)
        self.currentThreeDObj = currentThreeDObj
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        threeDObjBar.loadLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        threeDObjBar.setCurrentThreeDObj(type: currentThreeDObj)
    }
}

extension ThreeDObjectViewController {

    private func setUpLayout() {
        view.addSubViews(
            threeDObjBar,
            doneButton
        )

        setUpNavigationBar()
    }

    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)

        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        doneButton.titleLabel?.font = .regular(ofSize: .small)
        doneButton.tintColor = .white

        threeDObjBar.delegate = self
        threeDObjBar.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: doneButton)
        ]
    }

    @objc private func didTapDoneButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ThreeDObjectBarDelegate

extension ThreeDObjectViewController: ThreeDObjectBarDelegate {

    func didSelectThreeDObject(with type: ThreeDObjectType) {
        currentThreeDObj = type
        delegate?.didSelectThreeDObject(with: type)
    }
}
