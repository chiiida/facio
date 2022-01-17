//
//  HomeViewController.swift
//  Facio
//
//  Created by Chananchida Fuachai on 27/9/2564 BE.
//

import UIKit
import ARKit
import SnapKit

final class HomeViewController: UIViewController{

    private let settingsButton = UIButton(type: .system)
    private let menuBar = MenuBar()

    private var arView = ARSCNView(frame: .zero)
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
            $0.bottom.equalToSuperview().inset(165.0)
        }

        settingsButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(40.0)
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
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)

        node.geometry?.firstMaterial?.fillMode = .lines

        return node
    }

    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }

        faceGeometry.update(from: faceAnchor.geometry)
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
        // TODO: implement in integration
        if #available(iOS 13.0, *) {
            let imagepickerVC = ImagePickerViewController()
            let navVC = UINavigationController(rootViewController: imagepickerVC)
            navVC.modalPresentationStyle = .fullScreen
            navigationController?.present(imagepickerVC, animated: true)
        }
    }

    func didTapDrawButton() {
        let drawingBoardVC = DrawingBoardViewController()
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
