//
//  MasksManager.swift
//  CuriosSwift
//
//  Created by Emiaostein on 9/6/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import Foundation
import UIKit

struct MaskAttribute {
  let width: CGFloat
  let height: CGFloat
  let fixed: Bool
}

class MasksManager {
  
  static var maskTypes: [String: MaskAttribute] {
    
    return [
      "IsocelesTriangle": MaskAttribute(width: 100, height: 100, fixed: false),
      "Diamond": MaskAttribute(width: 100, height: 200, fixed: false),  //菱形[数]\ pentagon
      "RoundRetangle": MaskAttribute(width: 100, height: 100, fixed: false),
      "Pentagon": MaskAttribute(width: 100, height: 100, fixed: false), //五边形
      "Circle": MaskAttribute(width: 100, height: 100, fixed: false),
      "XShape": MaskAttribute(width: 100, height: 100, fixed: true),
      "Pentagram": MaskAttribute(width: 100, height: 100, fixed: true), //五角星
      "FanShape": MaskAttribute(width: 506, height: 314, fixed: true),
      "HeartShape": MaskAttribute(width: 132, height: 125, fixed: true)
      //      "Cross": MaskAttribute(width: 100, height: 100, fixed: false),
    ]
    
  }
  
  static let queue = NSOperationQueue()
  
  class func imageOfMask(type: String, AtFrame frame: CGRect, completed:(UIImage?, Bool) -> ()) -> NSOperation {
    
    let operation = NSBlockOperation()
    operation.addExecutionBlock { [unowned operation] () -> Void in
      
      if operation.cancelled {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          completed(nil, false)
        })
        return
      }
      
      if let image = self.drawMaskImage(type, AtFrame: frame) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          completed(image, true)
        })
      } else {
        completed(nil, false)
      }
      
    }
    
    queue.addOperation(operation)
    return operation
  } // end
  
  class func bezierPathWithMask(type: String, atFrame frame: CGRect) -> UIBezierPath {
    
    switch type {
    case "RoundRetangle":
      return CuriosMaskKit.drawRoundRetanglePath(frame: frame)
    case "IsocelesTriangle":
      return CuriosMaskKit.drawTrianglePath(frame: frame)
    case "Circle":
      return CuriosMaskKit.drawCirclePath(frame: frame)
    case "Diamond":
      return CuriosMaskKit.drawDiamondPath(frame: frame)
    case "Pentagon":
      return CuriosMaskKit.drawPentagonPath(frame: frame)
    case "Pentagram":
      return CuriosMaskKit.drawPentagramPath(frame: frame)
    case "HeartShape":
      return CuriosMaskKit.drawHeartPath(frame: frame)
    case "FanShape":
      return CuriosMaskKit.drawFanPath(frame: frame)
    case "XShape":
      return CuriosMaskKit.drawXPath(frame: frame)
    default:
      return UIBezierPath()
    }
  } // end
  
  private class func drawMaskImage(type: String, AtFrame frame: CGRect) -> UIImage? {
    
    //    return UIImage(named: "")!
    switch type {
    case "RoundRetangle":
      return CuriosMaskKit.imageOfRoundRetangle(frame: frame)
    case "IsocelesTriangle":
      return CuriosMaskKit.imageOfTriangle(frame: frame)
    case "Circle":
      return CuriosMaskKit.imageOfCircle(frame: frame)
    case "Diamond":
      return CuriosMaskKit.imageOfDiamond(frame: frame)
    case "Pentagon":
      return CuriosMaskKit.imageOfPentagon(frame: frame)
    case "Pentagram":
      return CuriosMaskKit.imageOfPentagram(frame: frame)
    case "HeartShape":
      return CuriosMaskKit.imageOfHeart(frame: frame)
    case "FanShape":
      return CuriosMaskKit.imageOfFan(frame: frame)
    case "XShape":
      return CuriosMaskKit.imageOfX(frame: frame)
    default:
      return nil
    }
    
  }
  
  
  
}