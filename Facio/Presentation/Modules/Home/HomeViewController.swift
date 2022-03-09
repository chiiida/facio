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
    
    private var arView = ARView()
    private var viewModel: HomeViewModelProtocol!
    
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
            settingsButton,
            menuBar
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
    }
    
    private func setUpViews() {
        arView.delegate = self
        arView.scene = SCNScene()
        
        settingsButton.setImage(Asset.common.settings(), for: .normal)
        settingsButton.tintColor = .primaryGray
        
        menuBar.delegate = self
    }
}

// MARK: - ARSCNViewDelegate

extension HomeViewController: ARSCNViewDelegate {
    
    func sessionWasInterrupted(_ session: ARSession) {}
    
    func sessionInterruptionEnded(_ session: ARSession) {}
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    
    func session(
        _ session: ARSession,
        cameraDidChangeTrackingState camera: ARCamera
    ) {}
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let device: MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.transparency = 0.0
        
        arView.updateFeatures(for: node, using: faceAnchor)
        
        return node
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor
    ) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        arView.updateFeatures(for: node, using: faceAnchor)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        let faceNode = FaceNode(at: FeatureIndices.nose)
        let timestamp = Date().timeIntervalSince1970
        let drawNodeName = "draw\(timestamp)"
        faceNode.name = drawNodeName
        faceNode.addImage(image: pickedImage)
        arView.addNode(faceNode)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - DrawingBoardDelegate

extension HomeViewController: DrawingBoardDelegate {
    
    func didFinishDrawing(_ image: UIImage) {
        let faceNode = FaceNode(at: FeatureIndices.nose)
        let timestamp = Date().timeIntervalSince1970
        let drawNodeName = "draw\(timestamp)"
        faceNode.name = drawNodeName
        faceNode.addImage(image: image)
        arView.addNode(faceNode)
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

        arView.addNode(node)
    }
}
