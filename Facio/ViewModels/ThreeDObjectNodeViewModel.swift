//
//  ObjectNodeViewModel.swift
//  Facio
//
//  Created by Chananchida Fuachai on 11/4/2565 BE.
//

import SceneKit

enum ThreeDObjectType: String, CaseIterable {

    case none
    case bagelGlasses
    case pizzaFace
    case fruitHead
    case microphone

    var title: String {
        switch self {
        case .none: return "None"
        case .bagelGlasses: return "Bagel Glasses"
        case .pizzaFace: return "Pizza Face"
        case .fruitHead: return "Fruit Head"
        case .microphone: return "Microphone"
        }
    }
}

protocol ThreeDObjectNodeViewModelProtocol: AnyObject {
    
    var objectType: ThreeDObjectType { get set }
    var currentObject: SCNScene? { get set }
    
    func addObject(with type: ThreeDObjectType)
    func removeObject()
}

class ThreeDObjectNodeViewModel: ThreeDObjectNodeViewModelProtocol {
    
    var objectType: ThreeDObjectType = .none
    var currentObject: SCNScene?
    
    func addObject(with type: ThreeDObjectType) {
        removeObject()

        if type != .none {
            objectType = type
            guard let sceneNode = SCNScene(named: "art.scnassets/Models/\(type).scn")
            else { return }
            currentObject = sceneNode
        }
    }
    
    func removeObject() {
        if currentObject != nil {
            currentObject?.rootNode.removeFromParentNode()
            currentObject = nil
            objectType = .none
        }
    }
}
