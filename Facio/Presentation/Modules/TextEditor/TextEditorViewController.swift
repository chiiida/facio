//
//  TextEditorViewController.swift
//  Facio
//
//  Created by Sirikonss on 2/2/2565 BE.
//

import UIKit
import SceneKit
import ARKit
import Alderis

final class TextEditorViewController: UIViewController, ColorPickerDelegate {
    
    private var text = " "
    private let textField = UITextView()
    private let colorBar = UIView()
    private let doneButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let colorButton = UIButton(type: .custom)
    private let blackColor = UIButton(type: .custom)
    private let blueColor = UIButton(type: .custom)
    private let greenColor = UIButton(type: .custom)
    private let yellowColor = UIButton(type: .custom)
    private let redColor = UIButton(type: .custom)
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpViews()
        setUpFooter()
        dismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        colorBar.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemGray5) ).cgColor
        blackColor.layer.backgroundColor = UIColor(ciColor: .black ).cgColor
        blueColor.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemBlue) ).cgColor
        greenColor.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemGreen) ).cgColor
        yellowColor.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemYellow) ).cgColor
        redColor.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemRed) ).cgColor
        colorButton.setBackgroundImage(Asset.common.color(), for: .normal)
        let buttons = [blackColor, blueColor, greenColor, yellowColor, redColor, colorButton]
        buttons.forEach {
            $0.layer.cornerRadius = $0.bounds.size.width / 2
            $0.layer.borderColor = UIColor(ciColor: .white).cgColor
            $0.layer.borderWidth = 3
        }
    }
    
}

extension TextEditorViewController {
    
    private func setUpLayout() {
        view.addSubViews(
            textField
        )
        
        textField.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(100.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
            $0.bottom.equalToSuperview().inset(100.0.bottomSafeAreaAdjusted)
        }
        
        textField.center = self.view.center
        textField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.autocapitalizationType = .words
        textField.textAlignment = .center
    }

    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        setUpHeader()
        setUpFooter()
        setUpNavigationBar()
    }
    
    private func setUpHeader() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        let buttons = [doneButton, cancelButton]
        buttons.forEach {
            $0.titleLabel?.font = .regular(ofSize: .small)
            $0.tintColor = .primaryGray
        }
    }
    
    private func setUpFooter() {
        view.addSubViews(
            colorBar,
            blackColor,
            blueColor,
            greenColor,
            yellowColor,
            redColor,
            colorButton
        )
        // colorBar
        colorBar.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(180.0)
            $0.leading.equalToSuperview().inset(0.0)
            $0.bottom.equalToSuperview().inset(0.0.bottomSafeAreaAdjusted)
        }
        
        blackColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(70.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(50.0)
        }
        
        blueColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(70.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(100.0)
        }
        
        greenColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(70.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(150.0)
        }
        
        yellowColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(70.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(200.0)
        }
        redColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(70.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(250.0)
        }
        
        colorButton.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(70.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(300.0)
        }
        
        blackColor.addTarget(self, action: #selector(didTapBlackColor), for: .touchUpInside)
        blueColor.addTarget(self, action: #selector(didTapBlueColor), for: .touchUpInside)
        greenColor.addTarget(self, action: #selector(didTapGreenColor), for: .touchUpInside)
        yellowColor.addTarget(self, action: #selector(didTapYellowColor), for: .touchUpInside)
        redColor.addTarget(self, action: #selector(didTapRedColor), for: .touchUpInside)
        colorButton.addTarget(self, action: #selector(didTapSelectColor), for: .touchUpInside)
    }
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton)
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: doneButton)
        ]
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton() {
        self.text = textField.text!
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func didTapBlackColor() {
        textField.textColor = .black
    }
    
    @objc private func didTapBlueColor() {
        textField.textColor = .systemBlue
    }
    
    @objc private func didTapGreenColor() {
        textField.textColor = .systemGreen
    }
    
    @objc private func didTapYellowColor() {
        textField.textColor = .systemYellow
    }
    
    @objc private func didTapRedColor() {
        textField.textColor = .red
    }
    
    @objc private func didTapSelectColor() {
        let colorPickerVC = ColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.configuration = ColorPickerConfiguration(color: .white)
        present(colorPickerVC, animated: true)
    }
    
    @objc(colorPicker:didSelectColor:)
    func colorPicker(_ colorPicker: ColorPickerViewController, didSelect selectedColor: UIColor) {
        textField.textColor = selectedColor
        colorButton.layer.backgroundColor = selectedColor.cgColor
    }
    
    @objc(colorPicker:didAcceptColor:)
    func colorPicker(_ colorPicker: ColorPickerViewController, didAccept selectedColor: UIColor) {
        textField.textColor = selectedColor
        colorButton.layer.backgroundColor = selectedColor.cgColor
    }
}

extension UIViewController {
    
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
