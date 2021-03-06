//
//  ContainerNode.swift
//  CuriosSwift
//
//  Created by Emiaostein on 5/15/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import UIKit

class ContainerNode: ASDisplayNode, IContainer {
    
    var containerSize: CGSize{
        get {
            return bounds.size
        }
    }
    var containerPostion: CGPoint{
        get {
            return position
        }
    }
    
    var containerRotation: CGFloat{
        get{
            return containerModel.rotation
        }
    }
    
    private let containerModel: ContainerModel
    private var component: IComponent!
    var componentNode: ASDisplayNode!
    private let aspectRatio: CGFloat
    
    init(postion: CGPoint, size: CGSize, rotation:CGFloat, aspectRatio theAspectRatio: CGFloat,aContainerModel: ContainerModel) {
        self.aspectRatio = theAspectRatio
        self.containerModel = aContainerModel
        
        super.init()
        position = postion
        bounds.size = size
        transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
        component = containerModel.component.createComponent()
        
        if let aCom = component as? ASDisplayNode {
            println("addSubnode aCom = \(aCom)")
            addSubnode(aCom)
        }
    }
    
    func containAcontainer(aContainerModel: ContainerModel) -> Bool {
        
        return containerModel.isEqual(aContainerModel)
    }
    
    // MARK: - IContainer
    func responderToLocation(location: CGPoint, onTargetView targetVew: UIView) -> Bool {
        let point = targetVew.convertPoint(location, toView: view)
        return CGRectContainsPoint(bounds, point)
    }
    
    func becomeFirstResponder() {
        component.iBecomeFirstResponder()
    }
    
    func resignFirstResponder() {
        component.iResignFirstResponder()
    }
    
    func isFirstResponder() -> Bool {
        return component.iIsFirstResponder()
    }
    
    func setTransation(translation: CGPoint) {
        
        self.position.x += translation.x
        self.position.y += translation.y
        containerModel.x += translation.x / aspectRatio
        containerModel.y += translation.y / aspectRatio
    }
    
    func setResize(size: CGSize, center: CGPoint) {
        
        bounds.size = size
        position.x += center.x
        position.y += center.y
        containerModel.width = size.width / aspectRatio
        containerModel.height = size.height / aspectRatio
        containerModel.x = frame.origin.x / aspectRatio
        containerModel.y = frame.origin.y / aspectRatio
    }
    
    func setRotation(incrementAngle: CGFloat) {
        transform = CATransform3DMakeRotation(incrementAngle, 0, 0, 1)
        containerModel.rotation = incrementAngle
    }
}

// MARK: - private method
extension ContainerNode {
    
        override func layout() {
            for subNode in subnodes as! [ASDisplayNode] {
                subNode.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)
            }
        }
    
}
