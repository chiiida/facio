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

protocol TextEditorDelegate: AnyObject {
    
    func didFinishTyping(_ text: String, color: UIColor, size: CGFloat, font: String)
}

final class TextEditorViewController: UIViewController, ColorPickerDelegate {
    
    //    Default values
    private var text = " "
    private var color = UIColor.white
    private var fontSize = CGFloat(30.0)
    private var fontName = "OpenSans-Regular"
    
    private let textField = UITextView()
    private let fontSlider = UISlider()
    private let navBar = UIView()
    private let colorBar = UIView()
    
    //    Button
    private let doneButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    private let colorButton = UIButton(type: .custom)
    private let blackColor = UIButton(type: .custom)
    private let blueColor = UIButton(type: .custom)
    private let greenColor = UIButton(type: .custom)
    private let yellowColor = UIButton(type: .custom)
    private let redColor = UIButton(type: .custom)
    
    private let nunitoFont = UIButton(type: .custom)
    private let openSansFont = UIButton(type: .custom)
    private let oswaldFont = UIButton(type: .custom)
    private let poppinsFont = UIButton(type: .custom)
    private let firaMonoFont = UIButton(type: .custom)
    private let mrDeHavilandFont = UIButton(type: .custom)
    
    weak var delegate: TextEditorDelegate?
    
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
        navBar.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemGray6) ).cgColor
        colorBar.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemGray6) ).cgColor
        blackColor.layer.backgroundColor = UIColor(ciColor: .black ).cgColor
        blueColor.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemBlue) ).cgColor
        greenColor.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemGreen) ).cgColor
        yellowColor.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemYellow) ).cgColor
        redColor.layer.backgroundColor = UIColor(ciColor: CIColor(color: .systemRed) ).cgColor
        colorButton.setBackgroundImage(Asset.common.color(), for: .normal)
        let buttons = [
            blackColor, blueColor, greenColor, yellowColor, redColor,colorButton,
            nunitoFont, openSansFont, oswaldFont, poppinsFont, firaMonoFont, mrDeHavilandFont
        ]
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
    }
    
    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        textField.center = self.view.center
        textField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        textField.textColor = .white
        textField.font = UIFont(name: self.fontName, size: self.fontSize)
        textField.autocapitalizationType = .words
        textField.textAlignment = .center
        
        setUpHeader()
        setUpFooter()
        setUpNavigationBar()
    }
    
    private func setUpHeader() {
        view.addSubview(
            navBar
        )
        
        navBar.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(95.0)
            $0.leading.equalToSuperview().inset(0.0)
            $0.top.equalToSuperview().inset(0.0.topSafeAreaAdjusted)
        }
        
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
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton)
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: doneButton)
        ]
    }
    
    private func setUpFooter() {
        view.addSubViews(
            colorBar,
            blackColor,
            blueColor,
            greenColor,
            yellowColor,
            redColor,
            colorButton,
            fontSlider
        )
        
        colorBar.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(180.0)
            $0.leading.equalToSuperview().inset(0.0)
            $0.bottom.equalToSuperview().inset(0.0.bottomSafeAreaAdjusted)
        }
        
        setUpFontSlider()
        setUpColorButton()
        setUpFontSelector()
    }
    
    private func setUpFontSelector() {
        view.addSubViews(
            openSansFont,
            nunitoFont,
            oswaldFont,
            poppinsFont,
            firaMonoFont,
            mrDeHavilandFont
        )
        
        openSansFont.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(200.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(25.0)
        }
        
        nunitoFont.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(200.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(85.0)
        }
        
        oswaldFont.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(200.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(145.0)
        }
        
        poppinsFont.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(200.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(205.0)
        }
        
        firaMonoFont.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(200.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(265.0)
        }
        
        mrDeHavilandFont.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(200.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(325.0)
        }
        
        setUpFontButton()
    }
    
    private func setUpFontButton() {
        let buttons = [nunitoFont, openSansFont, oswaldFont, poppinsFont, firaMonoFont, mrDeHavilandFont]
        buttons.forEach {
            $0.setTitle("Aa", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
        openSansFont.titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 20)
        nunitoFont.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 20)
        oswaldFont.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        poppinsFont.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 20)
        firaMonoFont.titleLabel?.font = UIFont(name: "FiraMono-Regular", size: 20)
        mrDeHavilandFont.titleLabel?.font = UIFont(name: "MrDeHaviland-Regular", size: 20)
        
        openSansFont.addTarget(self, action: #selector(didTapOpenSansFont), for: .touchUpInside)
        nunitoFont.addTarget(self, action: #selector(didTapNunitoFont), for: .touchUpInside)
        oswaldFont.addTarget(self, action: #selector(didTapOswaldFont), for: .touchUpInside)
        poppinsFont.addTarget(self, action: #selector(didTapPoppinsFont), for: .touchUpInside)
        firaMonoFont.addTarget(self, action: #selector(didTapFiraMonoFont), for: .touchUpInside)
        mrDeHavilandFont.addTarget(self, action: #selector(didTapmrDeFont), for: .touchUpInside)
    }
    
    private func setUpFontSlider() {
        fontSlider.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.bottom.equalToSuperview().inset(110.0.bottomSafeAreaAdjusted)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }
        
        fontSlider.minimumValue = 10
        fontSlider.maximumValue = 100
        fontSlider.value = 30
        fontSlider.minimumValueImage = Asset.common.smallText()
        fontSlider.maximumValueImage = Asset.common.largeText()
        fontSlider.minimumTrackTintColor = .systemGray3
        fontSlider.trackRect(forBounds: CGRect(x: 10, y: 10, width: 100, height: 1))
        fontSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        fontSlider.isContinuous = true
        
    }
    
    private func setUpColorButton() {
        blackColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(50.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(50.0)
        }
        
        blueColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(50.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(100.0)
        }
        
        greenColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(50.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(150.0)
        }
        
        yellowColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(50.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(200.0)
        }
        redColor.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(50.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(250.0)
        }
        
        colorButton.snp.makeConstraints {
            $0.height.width.equalTo(35.0)
            $0.bottom.equalToSuperview().inset(50.0.bottomSafeAreaAdjusted)
            $0.leading.equalToSuperview().inset(300.0)
        }
        
        blackColor.addTarget(self, action: #selector(didTapBlackColor), for: .touchUpInside)
        blueColor.addTarget(self, action: #selector(didTapBlueColor), for: .touchUpInside)
        greenColor.addTarget(self, action: #selector(didTapGreenColor), for: .touchUpInside)
        yellowColor.addTarget(self, action: #selector(didTapYellowColor), for: .touchUpInside)
        redColor.addTarget(self, action: #selector(didTapRedColor), for: .touchUpInside)
        colorButton.addTarget(self, action: #selector(didTapSelectColor), for: .touchUpInside)
    }
    
    @objc func sliderValueDidChange(_ sender : UISlider!) {
        self.fontSize = CGFloat(sender.value)
        textField.font = UIFont(name: self.fontName, size: CGFloat(sender.value))
    }
    
    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton() {
        self.text = textField.text!
        delegate?.didFinishTyping(self.text, color: self.color, size: self.fontSize, font: self.fontName)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapNunitoFont() {
        textField.font = UIFont(name: "Nunito-Regular", size: self.fontSize)
        self.fontName = "Nunito-Regular"
    }
    
    @objc private func didTapOpenSansFont() {
        textField.font = UIFont(name: "OpenSans-Regular", size: self.fontSize)
        self.fontName = "OpenSans-Regular"
    }
    
    @objc private func didTapOswaldFont() {
        textField.font = UIFont(name: "Oswald-Regular", size: self.fontSize)
        self.fontName = "Oswald-Regular"
    }
    
    @objc private func didTapPoppinsFont() {
        textField.font = UIFont(name: "Poppins-Regular", size: self.fontSize)
        self.fontName = "Poppins-Regular"
    }
    
    @objc private func didTapFiraMonoFont() {
        textField.font = UIFont(name: "FiraMono-Regular", size: self.fontSize)
        self.fontName = "FiraMono-Regular"
    }
    
    @objc private func didTapmrDeFont() {
        textField.font = UIFont(name: "MrDeHaviland-Regular", size: self.fontSize)
        self.fontName = "MrDeHaviland-Regular"
    }
    
    @objc private func didTapBlackColor() {
        textField.textColor = .black
        self.color = UIColor.black
    }
    
    @objc private func didTapBlueColor() {
        textField.textColor = .systemBlue
        self.color = UIColor.systemBlue
    }
    
    @objc private func didTapGreenColor() {
        textField.textColor = .systemGreen
        self.color = UIColor.systemGreen
    }
    
    @objc private func didTapYellowColor() {
        textField.textColor = .systemYellow
        self.color = UIColor.systemYellow
    }
    
    @objc private func didTapRedColor() {
        textField.textColor = .red
        self.color = UIColor.red
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
        self.color = selectedColor
        colorButton.layer.backgroundColor = selectedColor.cgColor
    }
    
    @objc(colorPicker:didAcceptColor:)
    func colorPicker(_ colorPicker: ColorPickerViewController, didAccept selectedColor: UIColor) {
        textField.textColor = selectedColor
        self.color = selectedColor
        colorButton.layer.backgroundColor = selectedColor.cgColor
    }
}

extension UIViewController {
    
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
