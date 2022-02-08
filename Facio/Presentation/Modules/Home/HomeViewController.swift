//
//  HomeViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 27/9/2564 BE.
//

import UIKit
import ARKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let settingsButton = UIButton(type: .system)
    private let menuBar = MenuBar()
    
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
        arView.autoenablesDefaultLighting = true
        
        settingsButton.setImage(Asset.common.settings(), for: .normal)
        settingsButton.tintColor = .primaryGray
        
        menuBar.delegate = self
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
        // TODO: implement in integration
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

        let faceNode = FaceNode(at: FeatureIndices.nose)
        let timestamp = Date().timeIntervalSince1970
        let imageNodeName = "image\(timestamp)"
        faceNode.name = imageNodeName
        let viewModel = FaceNodeViewModel(node: faceNode)
        viewModel.addImage(pickedImage)
        arView.addNode(from: viewModel)
        dismiss(animated: true, completion: nil)
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
    }
}
