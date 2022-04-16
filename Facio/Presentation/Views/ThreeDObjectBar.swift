//
//  ThreeDObjectBar.swift
//  Facio
//
//  Created by Chananchida Fuachai on 11/4/2565 BE.
//

import UIKit

protocol ThreeDObjectBarDelegate: AnyObject {

    func didSelectThreeDObject(with type: ThreeDObjectType)
}

class ThreeDObjectBar: UIView {

    private let threeDObjPicker = UIPickerView()
    private let threeDObjList: [ThreeDObjectType] = ThreeDObjectType.allCases

    private var currentThreeDObj: ThreeDObjectType = .none

    weak var delegate: ThreeDObjectBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadLayoutSubviews() {
        threeDObjPicker.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(500)
        }
        threeDObjPicker.subviews.forEach { $0.backgroundColor = .clear }
    }

    func setCurrentThreeDObj(type: ThreeDObjectType) {
        currentThreeDObj = type
        let index = threeDObjList.firstIndex(of: type) ?? 0
        threeDObjPicker.selectRow(index, inComponent: 0, animated: true)
    }

    private func setUpLayout() {
        self.addSubViews(
            threeDObjPicker
        )
        threeDObjPicker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
    }

    private func setUpViews() {
        backgroundColor = .white

        threeDObjPicker.dataSource = self
        threeDObjPicker.delegate = self
        threeDObjPicker.backgroundColor = .clear
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension ThreeDObjectBar: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return threeDObjList.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let optionView = UIView()
        optionView.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        optionView.backgroundColor = .clear

        let optionImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 75.0, height: 75.0))
        optionImageView.image = UIImage(named: "ThreeDObject/\(threeDObjList[row])")
        optionImageView.contentMode = .scaleAspectFill
        optionImageView.layer.masksToBounds = false
        optionImageView.layer.borderColor = UIColor.darkGray.cgColor
        optionImageView.layer.borderWidth = 3.0
        optionImageView.layer.cornerRadius = optionImageView.frame.width / 2
        optionImageView.clipsToBounds = true

        let optionLabel = UILabel()
        optionLabel.font = .regular(.comfortaa, ofSize: .xxSmall)
        optionLabel.textColor = .primaryGray
        optionLabel.text = threeDObjList[row].title
        optionLabel.textAlignment = .center

        optionView.addSubViews(optionImageView, optionLabel)
        optionView.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        optionLabel.snp.makeConstraints {
            $0.top.equalTo(optionImageView.snp.bottom).offset(10.0)
            $0.centerX.equalTo(optionImageView)
        }

        return optionView
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentThreeDObj = threeDObjList[row]
        delegate?.didSelectThreeDObject(with: currentThreeDObj)
    }
}
