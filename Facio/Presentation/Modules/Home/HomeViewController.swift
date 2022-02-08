//
//  HomeViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 27/9/2564 BE.
//

import UIKit
import ARKit
import SceneKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let settingsButton = UIButton(type: .system)
    private let menuBar = MenuBar()
    private let faceMaskMaterialMenu = MaterialMenuView()
    private let arToolsView = ToolsView()
    
    private var viewModel: HomeViewModelProtocol!
    var arView = ARView()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpViews()
        bind(to: viewModel)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Functions for standard AR view handling
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuBar.loadLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
        arView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
}

// MARK: – Private functions

extension HomeViewController {
    
    private func bind(to viewModel: HomeViewModelProtocol) {
        settingsButton.addAction(for: .touchUpInside) { _ in
            viewModel.didTapSettingsButton()
        }
    }
    
    private func setUpLayout() {
        view.addSubViews(
            arView,
            menuBar,
            faceMaskMaterialMenu,
            settingsButton,
            arToolsView
        )
        
        arView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(165.0.bottomSafeAreaAdjusted)
        }
        
        settingsButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(40.0.topSafeAreaAdjusted)
            $0.height.width.equalTo(35.0)
        }
        
        menuBar.snp.makeConstraints {
            $0.top.equalTo(arView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        faceMaskMaterialMenu.snp.makeConstraints {
            $0.bottom.equalTo(menuBar.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        arToolsView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(settingsButton.snp.centerY)
            $0.height.equalTo(30.0)
            $0.width.equalTo(80.0)
        }
    }
    
    private func setUpViews() {
        navigationController?.isNavigationBarHidden = true
        
        arView.delegate = self
        arView.scene = SCNScene()
        arView.autoenablesDefaultLighting = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapARView(_:)))
        arView.addGestureRecognizer(tapRecognizer)
        
        settingsButton.setImage(Asset.common.settings(), for: .normal)
        settingsButton.tintColor = .white

        faceMaskMaterialMenu.isHidden = true
        faceMaskMaterialMenu.delegate = self

        arToolsView.isHidden = true
        arToolsView.delegate = self
        
        menuBar.delegate = self
    }
    
    private func showFaceMaskMaterialMenu() {
        faceMaskMaterialMenu.show { [weak self] in
            guard let self = self else { return }
            self.faceMaskMaterialMenu.snp.remakeConstraints {
                $0.height.equalTo(160.0)
                $0.bottom.equalTo(self.menuBar.snp.top)
                $0.leading.trailing.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideFaceMaskMaterialMenu() {
        faceMaskMaterialMenu.hide { [weak self] in
            guard let self = self else { return }
            self.faceMaskMaterialMenu.snp.remakeConstraints {
                $0.height.equalTo(0.0)
                $0.bottom.equalTo(self.menuBar.snp.top)
                $0.leading.trailing.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }

    private func hideARTools() {
        arToolsView.isHidden = true
        arView.hideAllHighlights()
        hideFaceMaskMaterialMenu()
    }

    @objc private func didTapARView(_ sender: UITapGestureRecognizer) {
        hideARTools()

        let location = sender.location(in: arView)
        
        guard let nodeHitTest = arView.hitTest(location, options: nil).first
        else { return }
        let hitNode = nodeHitTest.node
        
        if hitNode.name == "mainNode",
           ((hitNode.geometry?.firstMaterial?.diffuse.contents as? UIImage) != nil) {
            showFaceMaskMaterialMenu()
        } else if let node = hitNode as? FaceNode {
            arView.showHighlight(node)
            arToolsView.node = hitNode
            arToolsView.isHidden = false
        }
    }
}

// MARK: - MenuBarDelegate

extension HomeViewController: MenuBarDelegate {
    
    func didTapCameraButton(state: MenuBar.CameraMode) {
        // TODO: implement in integration
    }
    
    func didTapRecordButton() {
        // TODO: implement in integration
    }
    
    func didTapImageButton() {
        let imagepickerVC = ImagePickerViewController()
        imagepickerVC.delegate = self
        present(imagepickerVC, animated: true, completion: nil)
    }
    
    func didTapDrawButton() {
        let drawingBoardVC = DrawingBoardViewController()
        drawingBoardVC.delegate = self
        let navVC = UINavigationController(rootViewController: drawingBoardVC)
        navVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navVC, animated: true)
    }
    
    func didTapTextButton() {
        let textEditorVC = TextEditorViewController()
        textEditorVC.delegate = self
        let navVC = UINavigationController(rootViewController: textEditorVC)
        navVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(navVC, animated: true)
        
    }
    
    func didTapBeautificationButton() {
        // TODO: implement in integration
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        let imageToDisplay = fixOrientation(img: pickedImage)
        let faceNode = FaceNode(at: FeatureIndices.nose)
        let timestamp = Date().timeIntervalSince1970
        let imageNodeName = "image\(timestamp)"
        faceNode.name = imageNodeName
        let viewModel = FaceNodeViewModel(node: faceNode)
        viewModel.addImage(imageToDisplay)
        arView.addNode(from: viewModel)
        dismiss(animated: true, completion: nil)
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
}

// MARK: - DrawingBoardDelegate

extension HomeViewController: DrawingBoardDelegate {
    
    func didFinishDrawing(_ image: UIImage, isFaceMask: Bool) {
        let drawingNode = DrawingNode(at: FeatureIndices.nose, isFaceMask: isFaceMask)
        let timestamp = Date().timeIntervalSince1970
        let drawNodeName = "draw\(timestamp)"
        drawingNode.name = drawNodeName
        let viewModel = DrawingNodeViewModel(node: drawingNode)
        viewModel.addImage(image)
        arView.addNode(from: viewModel)
        
        if isFaceMask {
            hideARTools()
            faceMaskMaterialMenu.resetValue()
            showFaceMaskMaterialMenu()
        }
    }
}

// MARK: - MaterialMenuViewDelegate

extension HomeViewController: MaterialMenuViewDelegate {
    
    func didUpdateMaterial(type: MaterialMenuView.MaterialType, value: Float) {
        let material = SCNMaterial()
        switch type {
        case .metalness: material.metalness.contents = value
        case .roughness: material.roughness.contents = value
        case .shininess: material.shininess = CGFloat(value)
        }
        arView.updateFaceMask(with: material)
    }
}

// MARK: - TextEditorDelegate

extension HomeViewController: TextEditorDelegate {
    
    func didFinishTyping(_ text: String, color: UIColor, size: CGFloat, font: String, width: CGFloat, height: CGFloat) {
        let typedText = SCNText(string: text, extrusionDepth: 0.2)
        typedText.font = UIFont(name: font, size: size)
        typedText.containerFrame = CGRect(origin: .init(x: 0.0, y: 0.0), size: CGSize(width: width, height: height))
        typedText.isWrapped = true
        typedText.alignmentMode = "center"
        typedText.truncationMode = "end"
        
        let material = SCNMaterial()
        material.diffuse.contents = color.cgColor
        typedText.materials = [material]
        
        let node = FaceNode(at: FeatureIndices.nose)
        let timestamp = Date().timeIntervalSince1970
        let textNodeName = "text\(timestamp)"
        node.name = textNodeName
        node.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node.geometry = typedText
        let viewModel = FaceNodeViewModel(node: node)
        
        arView.addNode(from: viewModel)
    }
}

// MARK: - ToolsViewDelegate

extension HomeViewController: ToolsViewDelegate {

    func didTapEditButton(_ node: SCNNode) {
        guard let node = node as? FaceNode else { return }
    }

    func didTapRemoveButton(_ node: SCNNode) {
        guard let node = node as? FaceNode else { return }
        arView.removeNode(node)
        hideARTools()
    }
}
