//
//  DrawingBoardViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 14/1/2565 BE.
//

import UIKit
import PencilKit
import LabelSwitch

protocol DrawingBoardDelegate: AnyObject {

    func didFinishDrawing(_ image: UIImage, isFaceMask: Bool)
}

final class DrawingBoardViewController: UIViewController {

    private let canvasView = PKCanvasView(frame: .zero)
    private let underlayingView = UIView()
    private let undoButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let faceMeshImageView = UIImageView()

    private var toggleSwitch = LabelSwitch()
    private var toolPicker: PKToolPicker?
    private var drawingType: DrawingType = .object

    weak var delegate: DrawingBoardDelegate?

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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpToolPicker()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        toolPicker = nil
    }
}

// MARK: – Private functions

extension DrawingBoardViewController {

    private func setUpLayout() {
        view.addSubViews(
            underlayingView,
            canvasView,
            faceMeshImageView
        )

        underlayingView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(15.0)
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview().inset(120.0.bottomSafeAreaAdjusted)
        }

        canvasView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(15.0)
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview().inset(32.0.bottomSafeAreaAdjusted)
        }

        faceMeshImageView.snp.makeConstraints {
            $0.center.equalTo(underlayingView.snp.center)
            $0.leading.trailing.equalTo(underlayingView)
            $0.height.equalTo(faceMeshImageView.snp.width)
            
        }
    }

    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = true
        view.backgroundColor = .lightGray

        underlayingView.backgroundColor = .white
        underlayingView.layer.cornerRadius = 5.0

        canvasView.layer.cornerRadius = 5.0
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 10)
        canvasView.delegate = self

        faceMeshImageView.image = Asset.drawingBoard.faceMesh()
        faceMeshImageView.isHidden = drawingType == .mask ? false : true

        let lhs = LabelSwitchConfig(
            text: "Mask",
            textColor: .primaryGray,
            font: .regular(ofSize: .xxSmall),
            backgroundColor: .lightGray
        )

        let rhs = LabelSwitchConfig(
            text: "Object",
            textColor: .primaryGray,
            font: .regular(ofSize: .xxSmall),
            backgroundColor: .lightGray
        )

        toggleSwitch = LabelSwitch(center: .zero, leftConfig: lhs, rightConfig: rhs)
        toggleSwitch.circleColor = .darkGray
        toggleSwitch.fullSizeTapEnabled = true
        toggleSwitch.layer.borderWidth = 1.0
        toggleSwitch.layer.borderColor = UIColor.darkGray.cgColor
        toggleSwitch.delegate = self

        setUpHeader()
        setUpNavigationBar()
    }

    private func setUpHeader() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)

        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        clearButton.isEnabled = false
        clearButton.isUserInteractionEnabled = false
        clearButton.alpha = 0.5

        undoButton.setTitle("Undo", for: .normal)
        undoButton.addTarget(self, action: #selector(didTapUndoButton), for: .touchUpInside)
        undoButton.isEnabled = false
        undoButton.isUserInteractionEnabled = false
        undoButton.alpha = 0.5

        let buttons = [doneButton, cancelButton, clearButton, undoButton]
        buttons.forEach {
            $0.titleLabel?.font = .regular(ofSize: .small)
            $0.tintColor = .primaryGray
        }
    }

    private func setUpToolPicker() {
        if #available(iOS 14.0, *) {
            toolPicker = PKToolPicker()
        } else {
            guard let window = view.window else { return }
            toolPicker = PKToolPicker.shared(for: window)
        }
        toolPicker?.setVisible(true, forFirstResponder: canvasView)
        toolPicker?.addObserver(canvasView)
        canvasView.becomeFirstResponder()

        canvasView.snp.remakeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(15.0)
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview().inset(120.0.bottomSafeAreaAdjusted)
        }
    }

    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: cancelButton),
            UIBarButtonItem(customView: undoButton),
            UIBarButtonItem(customView: clearButton)
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: doneButton)
        ]
        navigationItem.titleView = toggleSwitch
    }

    private func getPNGImage() -> UIImage? {
        let drawingImage = canvasView.drawing.image(
            from: canvasView.bounds,
            scale: UIScreen.main.scale
        )

        guard let data = drawingImage.pngData(),
              let pngImage = UIImage(data: data)
        else { return nil }
        return pngImage
    }

    @objc private func didTapClearButton() {
        canvasView.drawing = PKDrawing()
    }

    @objc private func didTapUndoButton() {
        undoManager?.undo()
    }

    @objc private func didTapCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapDoneButton() {
        guard let pngImage = getPNGImage() else { return }
        switch drawingType {
        case .object:
            delegate?.didFinishDrawing(pngImage, isFaceMask: false)
        case .mask:
            delegate?.didFinishDrawing(pngImage, isFaceMask: true)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }

    private func showFaceMash() {
        faceMeshImageView.isHidden = false
        canvasView.snp.remakeConstraints {
            $0.center.equalTo(faceMeshImageView)
            $0.edges.equalTo(faceMeshImageView)
        }
    }

    private func hideFaceMesh() {
        faceMeshImageView.isHidden = true
        canvasView.snp.remakeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(15.0)
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview().inset(120.0.bottomSafeAreaAdjusted)
        }
    }
}

extension DrawingBoardViewController {

    enum DrawingType {

        case object, mask
    }
}

// MARK: - PKCanvasViewDelegate

extension DrawingBoardViewController: PKCanvasViewDelegate {

    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        let isDrawing = !canvasView.drawing.bounds.isEmpty
        let buttons = [undoButton, clearButton]
        buttons.forEach {
            $0.isEnabled = isDrawing
            $0.isUserInteractionEnabled = isDrawing
            $0.alpha = 1.0
        }
    }
}

// MARK: - LabelSwitchDelegate

extension DrawingBoardViewController: LabelSwitchDelegate {

    func switchChangToState(sender: LabelSwitch) {
        didTapClearButton()
        switch sender.curState {
        case .L:
            drawingType = .object
            hideFaceMesh()
        case .R:
            drawingType = .mask
            showFaceMash()
        }
    }
}
