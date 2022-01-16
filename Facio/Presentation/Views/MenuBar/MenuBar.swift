//
//  MenuBar.swift
//  Facio
//
//  Created by Chananchida Fuachai on 13/1/2565 BE.
//

import UIKit

protocol MenuBarDelegate: AnyObject {

    func didTapCameraButton(state: MenuBar.CameraMode)
    func didTapRecordButton()
    func didTapImageButton()
    func didTapDrawButton()
    func didTapTextButton()
    func didTapBeautificationButton()
}

class MenuBar: UIView {

    private let cameraButton = UIButton()
    private let imageButton = UIButton()
    private let drawButton = UIButton()
    private let textButton = UIButton()
    private let beautificationButton = UIButton()
    private let cameraModePicker = UIPickerView()

    private var currentCameraMode: CameraMode = .camera
    private var cameraModeList = [CameraMode.camera.title, CameraMode.record.title]
    
    weak var delegate: MenuBarDelegate?

    init(cameraState: CameraMode = .camera) {
        super.init(frame: .zero)
        self.currentCameraMode = cameraState
        setUpLayout()
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadLayoutSubviews() {
        cameraModePicker.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cameraButton.snp.centerY).offset(cameraButton.frame.height / 2.0 + 30.0)
            $0.width.equalTo(50.0)
            $0.height.equalTo(self.bounds.width)
        }
        cameraModePicker.subviews.forEach { $0.backgroundColor = .clear }
    }

    private func setUpLayout() {
        self.addSubViews(
            cameraButton,
            imageButton,
            drawButton,
            textButton,
            beautificationButton,
            cameraModePicker
        )

        setUpButtons()

        cameraModePicker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
    }

    private func setUpButtons() {
        cameraButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25.0)
        }

        drawButton.snp.makeConstraints {
            $0.centerY.equalTo(cameraButton)
            $0.trailing.equalTo(cameraButton.snp.leading).offset(-35.0)
            $0.height.width.equalTo(35.0)
        }

        imageButton.snp.makeConstraints {
            $0.centerY.equalTo(cameraButton)
            $0.trailing.equalTo(drawButton.snp.leading).offset(-35.0)
            $0.height.width.equalTo(35.0)
        }

        textButton.snp.makeConstraints {
            $0.centerY.equalTo(cameraButton)
            $0.leading.equalTo(cameraButton.snp.trailing).offset(35.0)
            $0.height.width.equalTo(35.0)
        }

        beautificationButton.snp.makeConstraints {
            $0.centerY.equalTo(cameraButton)
            $0.leading.equalTo(textButton.snp.trailing).offset(35.0)
            $0.height.width.equalTo(35.0)
        }
    }

    private func setUpViews() {
        backgroundColor = .white

        cameraModePicker.dataSource = self
        cameraModePicker.delegate = self
        cameraModePicker.backgroundColor = .clear

        cameraButton.setImage(Asset.mainMenu.captureButton(), for: .normal)
        cameraButton.addTarget(self, action: #selector(didTapCameraButton(_:)), for: .touchUpInside)

        imageButton.setImage(Asset.mainMenu.imageIcon(), for: .normal)
        imageButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        imageButton.addTarget(self, action: #selector(didTapImageButton), for: .touchUpInside)

        drawButton.setImage(Asset.mainMenu.drawingIcon(), for: .normal)
        drawButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        drawButton.addTarget(self, action: #selector(didTapDrawButton), for: .touchUpInside)

        textButton.setImage(Asset.mainMenu.textIcon(), for: .normal)
        textButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        textButton.addTarget(self, action: #selector(didTapTextButton), for: .touchUpInside)

        beautificationButton.setImage(Asset.mainMenu.beautificationIcon(), for: .normal)
        beautificationButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        beautificationButton.addTarget(self, action: #selector(didTapBeautificationButton), for: .touchUpInside)
    }

    @objc private func didTapImageButton() {
        delegate?.didTapImageButton()
    }

    @objc private func didTapDrawButton() {
        delegate?.didTapDrawButton()
    }

    @objc private func didTapTextButton() {
        delegate?.didTapTextButton()
    }

    @objc private func didTapBeautificationButton() {
        delegate?.didTapBeautificationButton()
    }

    @objc private func didTapCameraButton(_ sender: UIButton) {
        delegate?.didTapCameraButton(state: currentCameraMode)
    }
}

extension MenuBar {

    enum CameraMode {

        case camera
        case record

        var title: String {
            switch self {
            case .camera: return "Camera"
            case .record: return "Video"
            }
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension MenuBar: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return cameraModeList.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: 80.0, height: 80.0)
        modeView.backgroundColor = .clear
        let modeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80.0, height: 80.0))
        modeLabel.font = .regular(.comfortaa, ofSize: .xxSmall)
        modeLabel.textColor = .primaryGray
        modeLabel.text = cameraModeList[row]
        modeLabel.textAlignment = .center
        modeView.addSubview(modeLabel)
        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        return modeView
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80.0
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCameraMode = row == 1 ? .record : .camera
        if currentCameraMode == .camera {
            cameraButton.setImage(Asset.mainMenu.captureButton(), for: .normal)
        } else {
            cameraButton.setImage(Asset.mainMenu.recordButton(), for: .normal)
        }
    }
}
