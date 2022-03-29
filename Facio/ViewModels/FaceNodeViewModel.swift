//
//  FaceNodeViewModel.swift
//  Facio
//
//  Created by Chananchida Fuachai on 1/2/2565 BE.
//

import SceneKit
import UIKit

protocol FaceNodeViewModelProtocol: AnyObject {

    var node: FaceNode { get set }
    var panPosition: SCNVector3? { get set }
    var originalRotation: SCNVector3? { get set }

    func updateMaterial(with material: SCNMaterial)
    func addImage(_ image: UIImage)
    func showHighlight()
    func hideHighlight()
    func updatePosition(with vector: SCNVector3)
}

class FaceNodeViewModel: FaceNodeViewModelProtocol {

    var node: FaceNode
    var panPosition: SCNVector3?
    var originalRotation: SCNVector3?

    init(node: FaceNode) {
        self.node = node
    }

    func addImage(_ image: UIImage) {
        node.image = image
        let imageRatio = image.size.width / image.size.height
        let isLandscapeImg = image.size.width > image.size.height
        if let plane = node.geometry as? SCNPlane {
            plane.width = isLandscapeImg ? 0.1 : 0.1 * imageRatio
            plane.height = isLandscapeImg ? 0.1 * (1 / imageRatio) : 0.1
            plane.firstMaterial?.diffuse.contents = image
            plane.firstMaterial?.isDoubleSided = true
        }

        addHighlightNode()
        hideHighlight()
    }
}

extension FaceNodeViewModelProtocol {

    func updateMaterial(with material: SCNMaterial) {
        node.material = material
    }

    func createLineNode(from origin: SCNVector3, to destination: SCNVector3, color: UIColor = .black) -> SCNNode {
        let indices: [Int32] = [0, 1]

        let source = SCNGeometrySource(vertices: [origin, destination])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let line = SCNGeometry(sources: [source], elements: [element])

        let lineNode = SCNNode(geometry: line)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = color
        line.materials = [planeMaterial]

        return lineNode
    }

    func addHighlightNode() {
        let (min, max) = node.boundingBox
        let zCoord = node.position.z
        let topLeft = SCNVector3Make(min.x, max.y, zCoord)
        let bottomLeft = SCNVector3Make(min.x, min.y, zCoord)
        let topRight = SCNVector3Make(max.x, max.y, zCoord)
        let bottomRight = SCNVector3Make(max.x, min.y, zCoord)

        let bottomSide = createLineNode(from: bottomLeft, to: bottomRight)
        let leftSide = createLineNode(from: bottomLeft, to: topLeft)
        let rightSide = createLineNode(from: bottomRight, to: topRight)
        let topSide = createLineNode(from: topLeft, to: topRight)

        [bottomSide, leftSide, rightSide, topSide].forEach {
            $0.name = "highlightingNode"
            node.addChildNode($0)
        }
    }

    func showHighlight() {
        let highlightningNodes = node.childNodes { child, _ -> Bool in
            child.name == "highlightingNode"
        }
        highlightningNodes.forEach {
            $0.isHidden = false
        }
    }

    func hideHighlight() {
        let highlightningNodes = node.childNodes { child, _ -> Bool in
            child.name == "highlightingNode"
        }
        highlightningNodes.forEach {
            $0.isHidden = true
        }
    }

    func updatePosition(with vector: SCNVector3) {
        node.position = vector
    }
}
