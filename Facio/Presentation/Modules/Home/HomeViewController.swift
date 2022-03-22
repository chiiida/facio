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
    var arRecoder: ARCapture?
    
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
        arRecoder = ARCapture(view: arView)
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
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(settingsButton.snp.top)
            $0.bottom.equalTo(menuBar.snp.top)
        }
    }
    
    private func setUpViews() {
        navigationController?.isNavigationBarHidden = true
        
        arView.delegate = self
        arView.scene = SCNScene()
        arView.autoenablesDefaultLighting = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapARView(_:)))
        arView.addGestureRecognizer(tapRecognizer)

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didMoveARNode(_:)))
        arView.addGestureRecognizer(panRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didResizeARNode(_:)))
        arView.addGestureRecognizer(pinchRecognizer)
        
        settingsButton.setImage(Asset.common.settings(), for: .normal)
        settingsButton.tintColor = .white

        faceMaskMaterialMenu.isHidden = true
        faceMaskMaterialMenu.delegate = self

        arToolsView.isHidden = true
        arToolsView.delegate = self
        
        menuBar.delegate = self
    }

    @objc private func didTapARView(_ sender: UITapGestureRecognizer) {
        hideARTools()

        let location = sender.location(in: arView)
        
        guard let nodeHitTest = arView.hitTest(location, options: nil).first
        else { return }
        let hitNode = nodeHitTest.node

        arToolsView.node = hitNode

        if hitNode.name == "mainNode",
           ((hitNode.geometry?.firstMaterial?.diffuse.contents as? UIImage) != nil) {
            showFaceMaskMaterialMenu()
            arToolsView.isHidden = false
            arToolsView.hidePosZSlider(true)
        } else if let node = hitNode as? FaceNode {
            arView.showHighlight(node)
            arToolsView.isHidden = false
            arToolsView.resetSlider()
            arToolsView.hidePosZSlider(false)
            if node as? DrawingNode != nil {
                arToolsView.hideEditButton(false)
            } else {
                arToolsView.hideEditButton(true)
            }
        }
        
        arView.selectedNode = hitNode
    }

    @objc private func didMoveARNode(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: arView)

        switch sender.state {
        case .began:
            guard let nodeHitTest = arView.hitTest(location, options: nil).first
            else { return }
            arView.lastDragPosition = nodeHitTest.localCoordinates
            arView.selectedNode = nodeHitTest.node
            arView.panStartZ = CGFloat(arView.projectPoint(nodeHitTest.node.position).z)
        case .changed:
            guard let lastDragPosition = arView.lastDragPosition,
                  let draggingNode = arView.selectedNode as? FaceNode,
                  let panStartZ = arView.panStartZ
            else { return }
            let localTouchPosition = arView.unprojectPoint(SCNVector3(location.x, location.y, panStartZ))
            let movementVector = SCNVector3(
                (localTouchPosition.x * -1.0) - lastDragPosition.x,
                (localTouchPosition.y * -1.0),
                lastDragPosition.z
            )
            arView.selectedNode?.localTranslate(by: movementVector)
            arView.updatePosition(for: draggingNode, with: movementVector)

            arView.lastDragPosition = localTouchPosition
        case .ended:
            (arView.lastDragPosition, arView.selectedNode, arView.panStartZ) = (nil, nil, nil)
        default:
            break
        }
    }
    
    @objc private func didResizeARNode(_ sender: UIPinchGestureRecognizer) {
        if let selectedNode = arView.selectedNode, selectedNode.name != "mainNode" {
            switch sender.state {
            case .changed:
                let pinchScaleX = Float(sender.scale) * selectedNode.scale.x
                let pinchScaleY = Float(sender.scale) * selectedNode.scale.y
                let pinchScaleZ = Float(sender.scale) * selectedNode.scale.z
                arView.selectedNode?.scale = SCNVector3(pinchScaleX, pinchScaleY, pinchScaleZ)
                sender.scale = 1
            default:
                break
            }
            
        }
    }
}

// Shared Functions

extension HomeViewController {

    func showFaceMaskMaterialMenu() {
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

    func hideFaceMaskMaterialMenu() {
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
    
    func hideARTools() {
        arToolsView.isHidden = true
        arView.hideAllHighlights()
        hideFaceMaskMaterialMenu()
    }
    
    func resetFaceMaskMenu() {
        faceMaskMaterialMenu.resetValue()
    }
}
