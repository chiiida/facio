//
//  ObjectNodeViewModel.swift
//  Facio
//
//  Created by Chananchida Fuachai on 11/4/2565 BE.
//

import SceneKit

enum ObjectType: String {
    
    case begalGlasses
    case pizzaFace
    case fruitHead
    case microphone
}

protocol ObjectNodeViewModelProtocol: AnyObject {
    
    var objectType: ObjectType? { get set }
    var currentObject: SCNScene? { get set }
    
    func addObject(with type: ObjectType)
    func removeObject()
}

class ObjectNodeViewModel: ObjectNodeViewModelProtocol {
    
    var objectType: ObjectType?
    var currentObject: SCNScene?
    
    func addObject(with type: ObjectType) {
        objectType = type
        guard let scencNode = SCNScene(named: "art.scnassets/Models/\(type).scn")
        else { return }
        currentObject = scencNode
    }
    
    func removeObject() {
        currentObject?.rootNode.removeFromParentNode()
        currentObject = nil
        objectType = nil
    }
}
