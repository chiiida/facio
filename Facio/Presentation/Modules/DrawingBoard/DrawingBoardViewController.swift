//
//  DrawingBoardViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 14/1/2565 BE.
//

import UIKit
import PencilKit

@available(iOS 13.0, *)
final class DrawingBoardViewController: UIViewController {

    private let canvasView = PKCanvasView(frame: .zero)
    private let undoButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let toggleSwitch = UISwitch()

    private var toolPicker: PKToolPicker?

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

@available(iOS 13.0, *)
extension DrawingBoardViewController {

    private func setUpLayout() {
        view.addSubViews(
            canvasView
        )

        canvasView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(15.0)
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview().inset(32.0.bottomSafeAreaAdjusted)
        }
    }

    private func setUpViews() {
        navigationController?.navigationItem.hidesBackButton = true
        view.backgroundColor = .lightGray

        canvasView.layer.cornerRadius = 5.0
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 10)
        canvasView.delegate = self

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
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PKCanvasViewDelegate

@available(iOS 13.0, *)
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
