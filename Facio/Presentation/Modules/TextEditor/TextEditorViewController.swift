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
    private let doneButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let colorButton = UIButton(type: .custom)
    
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
        self.dismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}

extension TextEditorViewController {
    
    private func setUpLayout() {
        view.addSubViews(
            textField
        )
        
        textField.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        textField.center = self.view.center
        textField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.autocapitalizationType = .words
        textField.textAlignment = .center
        
    }
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0.9
        
        setUpHeader()
        setUpNavigationBar()
    }
    
    private func setUpHeader() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
//        colorButton.frame = CGRect(x: 50, y: 50, width: 2, height: 2)
        colorButton.snp.makeConstraints {
            $0.height.width.equalTo(20.0)
        }
        colorButton.clipsToBounds = true
        colorButton.layer.masksToBounds = true
        colorButton.layer.cornerRadius = colorButton.frame.width / 2
        colorButton.layer.borderColor = UIColor(ciColor: .gray).cgColor
        colorButton.layer.backgroundColor = UIColor(ciColor: .white ).cgColor
        colorButton.layer.borderWidth = 1
        colorButton.addTarget(self, action: #selector(didTapSelectColor), for: .touchUpInside)
    
        let buttons = [doneButton, cancelButton]
        buttons.forEach {
            $0.titleLabel?.font = .regular(ofSize: .small)
            $0.tintColor = .primaryGray
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton)
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: doneButton),
            UIBarButtonItem(customView: colorButton)
        ]
        
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton() {
        self.text = textField.text!
        navigationController?.dismiss(animated: true, completion: nil)
        
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
//        print("\(self.color)")
    }
    
    @objc(colorPicker:didAcceptColor:)
    func colorPicker(_ colorPicker: ColorPickerViewController, didAccept selectedColor: UIColor) {
        textField.textColor = selectedColor
        colorButton.layer.backgroundColor = selectedColor.cgColor
//        print("\(self.color)")
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

