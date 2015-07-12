//
//  ContainerMaskView.swift
//  CuriosSwift
//
//  Created by Emiaostein on 5/5/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import UIKit

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    
    weak var target: T?
    let action: (T) -> () -> ()
    
    func performAction() {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TransitionChaged
}

class Control {
    
    
    var actions = [ControlEvent: TargetAction]()
    func setTarget<T: AnyObject>(target: T, action: (T) -> () -> (), aControlEvent: ControlEvent) {
        actions[aControlEvent] = TargetActionWrapper(target: target, action: action)
    }
    
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}


class ContainerMaskView: UIView, IMaskAttributeSetter {
    
    enum ControlStyle {
        case Rotaion, Resize, Transition, None
    }
    
    private weak var delegate: IMaskAttributeSetterProtocol?
    
    var controlStyle: ControlStyle = .None
    var angle: CGFloat = 0.0
    
    var settingPannel: UIImageView!
    var resizePannel: UIImageView!
    var rotationPannel: UIImageView!
    var deletePannel: UIImageView!
    
    var container: IContainer?
    
    var willDeletedTargetContainer = false
    
    var currentCenter = CGPointZero
    var ratio: CGFloat = 0.0 // height / width
    
    init(postion: CGPoint, size: CGSize, rotation: CGFloat, aRatio: CGFloat) {
        angle = rotation
        super.init(frame: CGRectZero)
        self.center = postion
        currentCenter = postion
        ratio = aRatio
        self.bounds.size = size
        self.transform = CGAffineTransformMakeRotation(rotation)
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        setupPannel()
        setupGestures()
        
        CUAnimationFactory.shareInstance.animationStateListener.bindAndFire ("MaskView"){[unowned self] finished -> Void in
        
            if finished {
                self.hidden = false
            } else {
                self.hidden = true
            }
        }
    }
    
    deinit {
        if let aContainer = container {
            aContainer.lockedListener.removeActionWithID("MaskView")
        }
        
        CUAnimationFactory.shareInstance.animationStateListener.removeActionWithID("MaskView")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        CuriosKit.drawControlPannel(frame: rect)
        resizePannel.center = CGPointMake(bounds.width, bounds.height)
        rotationPannel.center = CGPointMake(bounds.width, 0)
        deletePannel.center = CGPointMake(0, bounds.height)
        settingPannel.center = CGPointMake(0, 0)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMaskSize(size: CGSize) {
        
        bounds.size = size
        setNeedsDisplay()
    }
    
    func setupPannel() {
        
        let settingPannelImage = UIImage(named: "Editor_SettingPannel")
        settingPannel = UIImageView(image: settingPannelImage)
        settingPannel.bounds.size = CGSizeMake(40, 40)
        settingPannel.center = CGPointMake(0, 0)
        //        resizePannel.backgroundColor = UIColor.blackColor()
        addSubview(settingPannel)
        
        let resizePannelImage = UIImage(named: "Editor_ResizePannel")
        resizePannel = UIImageView(image: resizePannelImage)
        resizePannel.bounds.size = CGSizeMake(40, 40)
        resizePannel.center = CGPointMake(bounds.width, bounds.height)
//        resizePannel.backgroundColor = UIColor.blackColor()
        addSubview(resizePannel)
        
        let rotationPannelImage = UIImage(named: "Editor_RotationPannel")
        rotationPannel = UIImageView(image: rotationPannelImage)
        rotationPannel.bounds.size = CGSizeMake(40, 40)
        rotationPannel.center = CGPointMake(bounds.width, 0)
//        rotationPannel.backgroundColor = UIColor.blackColor()
        addSubview(rotationPannel)
        
        let deletePannelImage = UIImage(named: "Editor_DeletePannel")
        deletePannel = UIImageView(image: deletePannelImage)
        deletePannel.bounds.size = CGSizeMake(40, 40)
        deletePannel.center = CGPointMake(0, bounds.height)
//        deletePannel.backgroundColor = UIColor.blackColor()
        addSubview(deletePannel)
    }
    
    func setupGestures() {

        let pan = UIPanGestureRecognizer(target: self, action: "panAction:")
        let rot = UIRotationGestureRecognizer(target: self, action: "rotaionAction:")
        let pin = UIPinchGestureRecognizer(target: self, action: "pinchAction:")
        let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
        addGestureRecognizer(pan)
        addGestureRecognizer(rot)
        addGestureRecognizer(pin)
        addGestureRecognizer(tap)
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        
        let rec = retangle(bounds.size, CGPointMake(bounds.size.width / 2.0, bounds.size.height / 2.0))
        
        if let aContainer = container where aContainer.lockedListener.value == true {
            return rec(point)
        } else {
            let resizePannel = retangle(CGSizeMake(40, 40), CGPointMake(bounds.size.width, bounds.size.height))
            let rotationPannel = retangle(CGSizeMake(40, 40), CGPointMake(bounds.size.width, 0))
            let deletePannel = retangle(CGSizeMake(40, 40), CGPointMake(0, bounds.height))
            let setPannel = retangle(CGSizeMake(40, 40), CGPointMake(0, 0))
            return union(setPannel ,union(deletePannel, union(rotationPannel, (union(rec, resizePannel)))))(point)
        }
    }
    
//    func panAction(sender: UIPanGestureRecognizer) {
//        
//        let transition = sender.translationInView(self.superview!)
//        
//        if let aContainer = container {
//            aContainer.setTransation(transition)
//        }
//        self.center.x += transition.x
//        self.center.y += transition.y
//        
//        sender.setTranslation(CGPointZero, inView: self.superview)
//    }
    // MARK: - Gestures
    
    func tapAction(sender: UITapGestureRecognizer) {
        
        if let aContainer = container where aContainer.lockedListener.value == true {
            return
        }
        
        let point = sender.locationInView(self)
        
        let deleteRegion = retangle(CGSizeMake(40, 40), CGPointMake(0, bounds.height))
        let settingRegion = retangle(CGSizeMake(40, 40), CGPointMake(0, 0))
        
        if deleteRegion(point) {
            
            if let aDelegate = delegate {
                willDeletedTargetContainer = true
                aDelegate.maskAttributeWillDeleted(self)
            }
        } else if settingRegion(point) {
            
            if let aDelegate = delegate {
                aDelegate.maskAttributeWillSetting(self)
            }
        }
        
    }
    
    func rotaionAction(sender: UIRotationGestureRecognizer) {
        
        if let aContainer = container where aContainer.lockedListener.value == true {
            
            return
        }
        
        let rotation = sender.rotation
        
        switch sender.state {
            
        case .Began, .Changed:
            transform = CGAffineTransformMakeRotation(angle + rotation)
            if let aContainer = container {
//                aContainer.setRotation(angle + rotation)
            }
        case .Cancelled, .Ended:
            
            let newAngle = angle + rotation
            
            angle = newAngle <= 360 ? newAngle : newAngle % 360.0
            
        default:
            return
        }
        
    }
    
    var beginSize: CGSize = CGSizeZero
    
    func pinchAction(sender: UIPinchGestureRecognizer) {
        
        if let aContainer = container where aContainer.lockedListener.value == true {
            
            return
        }
        
        
        switch sender.state {
            
        case .Began:
            beginSize = bounds.size
            
        case .Changed:
            let scale = ceil((sender.scale - 1.0) * 100) / 100.0
            let widthDel = beginSize.width * scale
            let heightDel = beginSize.height * scale
            bounds.size.width = beginSize.width + widthDel
            bounds.size.height = beginSize.height + heightDel
            
            if let aContainer = container {
            }
            
        case .Ended, .Changed:
            return
            
        default:
            return
        }
        
        setNeedsDisplay()
    }
    
    var begainAngle: CGFloat = 0.0
    
    func panAction(sender: UIPanGestureRecognizer) {
        
        if let aContainer = container where aContainer.lockedListener.value == true {
            
            return
        }
        
        let rec = retangle(bounds.size, CGPointMake(bounds.size.width / 2.0, bounds.size.height / 2.0))
        let resizeRegion = retangle(CGSizeMake(40, 40), CGPointMake(bounds.size.width, bounds.size.height))
        let rotationRegion = retangle(CGSizeMake(40, 40), CGPointMake(bounds.size.width, 0))
        
        switch sender.state {
            
        case .Began:
            
            let position = sender.locationInView(self)
            
            switch position {
            case let point where rotationRegion(point):
                let location = sender.locationInView(superview!)
                begainAngle = atan2(location.y - center.y, location.x - center.x)
                
                controlStyle = .Rotaion
            case let point where resizeRegion(point):
                controlStyle = .Resize
            case let point where rec(point):
                controlStyle = .Transition
            default:
                controlStyle = .None
            }
            
        case .Changed:
            
            switch controlStyle {
                
            case .Transition:
                let transition = sender.translationInView(superview!)
                
                if let aContainer = container {
                    aContainer.setTransation(transition)
                }
                center.x += transition.x
                center.y += transition.y
                
                currentCenter = center
                
            case .Resize:
                let translationX = sender.translationInView(self).x
                let delX = translationX
                let delY = delX * ratio
                let sizeDel = CGPointMake(delX, delY)
//                let centerDel = sender.translationInView(superview!)
                let width = bounds.size.width + sizeDel.x
                let height = bounds.size.height + sizeDel.y
                
                let realWidth = width <= 50 ? 50 : width
                let realHeight = height <= 50 ? 50 : height
                
//                let delCenX = width <= 50 ? 0 : centerDel.x / 2.0
//                let delCenY = height <= 50 ? 0 : centerDel.y / 2.0
                
//                let centerX = center.x + delCenX
//                let centerY = center.y + delCenY
                
                bounds.size.width = realWidth // 对于屏幕的大小
                bounds.size.height = realHeight
//                center.x = centerX
//                center.y = centerY
                
                currentCenter = center
                
                if let aContainer = container {
                  
                }
                
            case .Rotaion:
                
                let location = sender.locationInView(superview!)
                let transition  = sender.translationInView(self)
                let ang = atan2(location.y - center.y, location.x - center.x)
                let angDel = ang - begainAngle
                transform = CGAffineTransformMakeRotation(angle + angDel)
                
                if let aContainer = container {
                }
                
            default:
                return
            }
            
            sender.setTranslation(CGPointZero, inView: self)
            sender.setTranslation(CGPointZero, inView: superview!)
            
        case .Cancelled, .Ended:
            
            switch controlStyle {
                
            case .Rotaion:
                let location = sender.locationInView(superview!)
                let ang = atan2(location.y - center.y, location.x - center.x)
                let angDel = ang - begainAngle
                angle += angDel
                
            default:
                return
            }

        default:
            return
        }
        
        setNeedsDisplay()
    }
}

// MARK: - IMaskAttributeSetter 
extension ContainerMaskView {
    
    static func createMask(postion: CGPoint, size: CGSize, rotation: CGFloat, aRatio: CGFloat) -> IMaskAttributeSetter {
        
        return ContainerMaskView(postion: postion, size: size, rotation: rotation, aRatio: aRatio)
    }
    
    func setDelegate(aDelegate: IMaskAttributeSetterProtocol) {
        delegate = aDelegate
    }
    func cancelDelegate() {
        delegate = nil
    }
    
    func setTarget(target: IContainer) {
        container = target
        
        container?.lockedListener.bindAndFire ("MaskView"){ [unowned self] locked -> Void in
            
            self.resizePannel.hidden = locked
            self.rotationPannel.hidden = locked
        }
        
        setNeedsDisplay()
    }
    func getTarget() -> IContainer? {
        return container
    }
    
    func remove() {
        
        if willDeletedTargetContainer {
            if let aContainer = container {
                aContainer.removed()
            }
        }
        
        
        cancelDelegate()
        removeFromSuperview()
    }
}
