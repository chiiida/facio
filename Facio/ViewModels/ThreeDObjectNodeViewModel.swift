//
//  ObjectNodeViewModel.swift
//  Facio
//
//  Created by Chananchida Fuachai on 11/4/2565 BE.
//

import SceneKit

enum ThreeDObjectType: String {
    
    case begalGlasses
    case pizzaFace
    case fruitHead
    case microphone
}

protocol ThreeDObjectNodeViewModelProtocol: AnyObject {
    
    var objectType: ThreeDObjectType? { get set }
    var currentObject: SCNScene? { get set }
    
    func addObject(with type: ThreeDObjectType)
    func removeObject()
}

class ThreeDObjectNodeViewModel: ThreeDObjectNodeViewModelProtocol {
    
    var objectType: ThreeDObjectType?
    var currentObject: SCNScene?
    
    func addObject(with type: ThreeDObjectType) {
        removeObject()
        
        objectType = type
        guard let sceneNode = SCNScene(named: "art.scnassets/Models/\(type).scn")
        else { return }
        currentObject = sceneNode
    }
    
    func removeObject() {
        currentObject?.rootNode.removeFromParentNode()
        currentObject = nil
        objectType = nil
    }
}
