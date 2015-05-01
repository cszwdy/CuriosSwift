//
//  Models.swift
//  CuriosSwift
//
//  Created by Emiaostein on 4/19/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import UIKit
import Mantle

class Model: MTLModel, MTLJSONSerializing {

    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [String: AnyObject]()
    }
}

class BookModel: Model {
    
    @objc enum FlipDirections: Int {
        case ver, hor
    }
    
    @objc  enum FlipTypes: Int {
        case aa, bb
    }
    
    var Id = ""
    var width = 0
    var height = 0
    var title = ""
    var desc = ""
    var flipDirection: FlipDirections = .ver
    var flipType: FlipTypes = .aa
    var background = ""
    var backgroundMusic = ""
    var pagesPath = ""
    var autherID = ""
    var publishDate: NSDate!
    var pagesInfo: [[String : String]] = [[:]]
    var pageModels: [PageModel] = []
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [
                "Id" : "ID",
             "width" : "MainWidth",
            "height" : "MainHeight",
             "title" : "MainTitle",
              "desc" : "MainDesc",
     "flipDirection" : "FlipDirection",
          "flipType" : "FlipType",
        "background" : "MainBackground",
   "backgroundMusic" : "MainMusic",
         "pagesPath" : "PagesPath",
          "autherID" : "AutherID",
       "publishDate" : "PublishDate",
         "pagesInfo" : "Pages"
        ]
    }
    
    // flipDirection
    class func flipDirectionJSONTransformer() -> NSValueTransformer {
        
        return NSValueTransformer.mtl_valueMappingTransformerWithDictionary([
            "ver":FlipDirections.ver.rawValue,
            "hor":FlipDirections.hor.rawValue
            ])
    }
    
    // fliptypes
    class func flipTypeJSONTransformer() -> NSValueTransformer {
        
        return NSValueTransformer.mtl_valueMappingTransformerWithDictionary([
            "aa":FlipTypes.aa.rawValue,
            "bb":FlipTypes.bb.rawValue
            ])
    }
    
    // publishDate
    class func publishDateJSONTransformer() -> NSValueTransformer {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let forwardBlock: MTLValueTransformerBlock! = {
            (dateStr: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, aerror: NSErrorPointer) -> AnyObject! in
            return dateFormatter.dateFromString(dateStr as! String)
        }

        let reverseBlock: MTLValueTransformerBlock! = {
            (date: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, error: NSErrorPointer) -> AnyObject! in
            return dateFormatter.stringFromDate(date as! NSDate)
        }

        return MTLValueTransformer(usingForwardBlock: forwardBlock, reverseBlock: reverseBlock)
    }
    
    // pageModels
    class func pageModelsJSONTransformer() -> NSValueTransformer {

        let forwardBlock: MTLValueTransformerBlock! = {
            (jsonArray: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, aerror: NSErrorPointer) -> AnyObject! in

//            let something: AnyObject! = MTLJSONAdapter.modelOfClass(ComponentModel.self, fromJSONDictionary: jsonDic as! [NSObject : AnyObject], error: aerror)
            let something: AnyObject! = MTLJSONAdapter.modelsOfClass(PageModel.self, fromJSONArray: jsonArray as! [PageModel], error: nil)
            return something
        }

        let reverseBlock: MTLValueTransformerBlock! = {
            (pages: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, error: NSErrorPointer) -> AnyObject! in
            let something: AnyObject! = MTLJSONAdapter.JSONArrayFromModels(pages as! [PageModel], error: nil)
            return something
        }

        return MTLValueTransformer(usingForwardBlock: forwardBlock, reverseBlock: reverseBlock)
    }
    
}

class PageModel: Model {
    
    var Id = ""
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var containers: [ContainerModel] = []
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [
                    "Id" : "ID",
                 "width" : "PageWidth",
                "height" : "PageHeight",
            "containers" : "Containers"
        ]
    }
    
    // congtainers
    class func containersJSONTransformer() -> NSValueTransformer {
        
        let forwardBlock: MTLValueTransformerBlock! = {
            (jsonArray: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, aerror: NSErrorPointer) -> AnyObject! in
            
            //            let something: AnyObject! = MTLJSONAdapter.modelOfClass(ComponentModel.self, fromJSONDictionary: jsonDic as! [NSObject : AnyObject], error: aerror)
            let something: AnyObject! = MTLJSONAdapter.modelsOfClass(ContainerModel.self, fromJSONArray: jsonArray as! [ContainerModel], error: nil)
            return something
        }
        
        let reverseBlock: MTLValueTransformerBlock! = {
            (containers: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, error: NSErrorPointer) -> AnyObject! in
            let something: AnyObject! = MTLJSONAdapter.JSONArrayFromModels(containers as! [ContainerModel], error: nil)
            return something
        }
        
        return MTLValueTransformer(usingForwardBlock: forwardBlock, reverseBlock: reverseBlock)
    }
}

class ContainerModel: Model {
    
    var Id = ""
    var x: CGFloat = 100.0
    var y: CGFloat = 100.0
    var width: CGFloat = 100.0 // bounds.width
    var height: CGFloat = 100.0 // bounds.height
    var rotation: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    var editable = true
    var animations:[Animation] = []
    var behaviors: [Behavior] = []
    var effects: [Effect] = []
    var component: ComponentModel! = NoneContentModel()

    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [
               "Id" : "ID",
                "x" : "ContainerX",
                "y" : "ContainerY",
            "width" : "ContaienrWidth",
           "height" : "ContainerHeight",
         "rotation" : "ContainerRotation",
            "alpha" : "ContainerAplha",
         "editable" : "Editable",
       "animations" : "Animations",
        "behaviors" : "Behaviors",
          "effects" : "Effect",
        "component" : "Component"
        ]
    }
    
    // animations
    class func animationsJSONTransformer() -> NSValueTransformer {
        
        let forwardBlock: MTLValueTransformerBlock! = {
            (jsonArray: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, aerror: NSErrorPointer) -> AnyObject! in
            
            //            let something: AnyObject! = MTLJSONAdapter.modelOfClass(ComponentModel.self, fromJSONDictionary: jsonDic as! [NSObject : AnyObject], error: aerror)
            let something: AnyObject! = MTLJSONAdapter.modelsOfClass(Animation.self, fromJSONArray: jsonArray as! [Animation], error: nil)
            return something
        }
        
        let reverseBlock: MTLValueTransformerBlock! = {
            (containers: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, error: NSErrorPointer) -> AnyObject! in
            let something: AnyObject! = MTLJSONAdapter.JSONArrayFromModels(containers as! [Animation], error: nil)
            return something
        }
        
        return MTLValueTransformer(usingForwardBlock: forwardBlock, reverseBlock: reverseBlock)
    }
    
    // behaviors
    class func behaviorsJSONTransformer() -> NSValueTransformer {
        
        let forwardBlock: MTLValueTransformerBlock! = {
            (jsonArray: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, aerror: NSErrorPointer) -> AnyObject! in
            
            //            let something: AnyObject! = MTLJSONAdapter.modelOfClass(ComponentModel.self, fromJSONDictionary: jsonDic as! [NSObject : AnyObject], error: aerror)
            let something: AnyObject! = MTLJSONAdapter.modelsOfClass(Behavior.self, fromJSONArray: jsonArray as! [Behavior], error: nil)
            return something
        }
        
        let reverseBlock: MTLValueTransformerBlock! = {
            (containers: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, error: NSErrorPointer) -> AnyObject! in
            let something: AnyObject! = MTLJSONAdapter.JSONArrayFromModels(containers as! [Behavior], error: nil)
            return something
        }
        
        return MTLValueTransformer(usingForwardBlock: forwardBlock, reverseBlock: reverseBlock)
    }
    
    // effects
    class func effectsJSONTransformer() -> NSValueTransformer {
        
        let forwardBlock: MTLValueTransformerBlock! = {
            (jsonArray: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, aerror: NSErrorPointer) -> AnyObject! in
            
            //            let something: AnyObject! = MTLJSONAdapter.modelOfClass(ComponentModel.self, fromJSONDictionary: jsonDic as! [NSObject : AnyObject], error: aerror)
            let something: AnyObject! = MTLJSONAdapter.modelsOfClass(Effect.self, fromJSONArray: jsonArray as! [Effect], error: nil)
            return something
        }
        
        let reverseBlock: MTLValueTransformerBlock! = {
            (containers: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, error: NSErrorPointer) -> AnyObject! in
            let something: AnyObject! = MTLJSONAdapter.JSONArrayFromModels(containers as! [Effect], error: nil)
            return something
        }
        
        return MTLValueTransformer(usingForwardBlock: forwardBlock, reverseBlock: reverseBlock)
    }
    
    // component
    class func componentJSONTransformer() -> NSValueTransformer {

        let forwardBlock: MTLValueTransformerBlock! = {
            (jsonDic: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, aerror: NSErrorPointer) -> AnyObject! in

            let something: AnyObject! = MTLJSONAdapter.modelOfClass(ComponentModel.self, fromJSONDictionary: jsonDic as! [NSObject : AnyObject], error: aerror)
            return something
        }

        let reverseBlock: MTLValueTransformerBlock! = {
            (componentModel: AnyObject!, succes: UnsafeMutablePointer<ObjCBool>, error: NSErrorPointer) -> AnyObject! in
            let something: AnyObject! = MTLJSONAdapter.JSONDictionaryFromModel(componentModel as! ComponentModel, error: error)
            return something
        }

        return MTLValueTransformer(usingForwardBlock: forwardBlock, reverseBlock: reverseBlock)
    }
}

class Animation: Model {
    
    @objc enum Types: Int {
        case None, Rotation, FlowUp
    }
    
    @objc enum EaseTypes: Int {
        case  Linear, EaseIn, EaseOut, EaseInOut
    }
    
    var type: Types = .None
    var delay: NSTimeInterval = 0
    var duration: NSTimeInterval = 0
    var repeat: Int = 0
    var easeType: EaseTypes = .Linear
    var attributes: [String : String] = [:]
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [
            
            "type" : "AnimationType",
           "delay" : "AnimationDelay",
        "duration" : "AnimationDuration",
          "repeat" : "AnimationRepeat",
        "easeType" : "AnimationEaseType",
      "attributes" : "AnimationData"
        ]
    }
    
    // type
    class func typeJSONTransformer() -> NSValueTransformer {
        
        return NSValueTransformer.mtl_valueMappingTransformerWithDictionary([
            "None":Types.None.rawValue,
            "Rotation":Types.Rotation.rawValue,
            "FlowUp":Types.FlowUp.rawValue
            ])
    }
    
    // easeType
    class func easeTypeJSONTransformer() -> NSValueTransformer {
        
        return NSValueTransformer.mtl_valueMappingTransformerWithDictionary([
            "Linear":EaseTypes.Linear.rawValue,
            "EaseIn":EaseTypes.EaseIn.rawValue,
            "EaseOut":EaseTypes.EaseOut.rawValue,
            "EaseInOut":EaseTypes.EaseInOut.rawValue,
            ])
    }
}

class Behavior: Model {
    
    @objc enum EventType: Int {
        case None, Click ,DoubleClick
    }
    
    @objc enum FunctionType: Int {
        case None, playMuisc
    }
    
    var eventType: EventType = .None
    var eventValue: Int = 1
    var eventId = ""
    var functionName: FunctionType = .None
    var functionValue: Int = 1
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [
            
            "eventType" : "EventName",
           "eventValue" : "EventValue",
              "eventId" : "ObjectID",
         "functionName" : "FunctionName",
        "functionValue" : "FunctionValue"
        ]
    }
    
    // eventType
    class func eventTypeJSONTransformer() -> NSValueTransformer {
        
        return NSValueTransformer.mtl_valueMappingTransformerWithDictionary([
            "None":EventType.None.rawValue,
            "Click":EventType.Click.rawValue,
            "DoubleClick":EventType.DoubleClick.rawValue
            ])
    }
    
    // functionName
    class func functionNameJSONTransformer() -> NSValueTransformer {
        
        return NSValueTransformer.mtl_valueMappingTransformerWithDictionary([
            "None":FunctionType.None.rawValue,
            "playMuisc":FunctionType.playMuisc.rawValue
            ])
    }
}

class Effect: Model {
    
    @objc enum EffectType: Int {
        case None, Shadow
    }
    
    var type: EffectType = .None
    var attributes: [String : AnyObject] = [:]
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [
            
            "type" : "EffectType",
      "attributes" : "EffectData"
        ]
    }
    
    // EffectType
    class func typeJSONTransformer() -> NSValueTransformer {
        
        return NSValueTransformer.mtl_valueMappingTransformerWithDictionary([
            "None":EffectType.None.rawValue,
            "Shadow":EffectType.Shadow.rawValue
            ])
    }
}

class ComponentModel: Model  {
    
    @objc enum Type: Int {
        case None, Text, Image
    }
    
    var type: Type = .None
    var attributes: [String : AnyObject] = [:]
    
    class func classForParsingJSONDictionary(JSONDictionary: [NSObject : AnyObject]!) -> AnyClass! {
        
        if let type = JSONDictionary["ComponentType"] as? NSString {
            
            switch type {
            case "Text":
                
                return TextContentModel.self
                
            case "Image":
                
                return ImageContentModel.self
            default:
                
                return NoneContentModel.self
                
            }
        } else {
            return NoneContentModel.self
        }
    }
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [
            
            "type" : "ComponentType",
      "attributes" : "ComponentData"
        ]
    }
    
    //TODO: type
    class func typeJSONTransformer() -> NSValueTransformer {
        
        return NSValueTransformer.mtl_valueMappingTransformerWithDictionary([
            "None":Type.None.rawValue,
            "Text":Type.Text.rawValue,
            "Image":Type.Image.rawValue,
            ])
    }
}

class NoneContentModel: ComponentModel {
}

class ImageContentModel: ComponentModel {
}

class TextContentModel: ComponentModel {
}

extension MTLJSONAdapter {
    
    //    class func modelOfClass<T: MTLModel>(T.Type, fromJSONDictionary: [String: AnyObject]?) -> (T?, NSError?) {
    //        var error: NSError?
    //        let model = modelOfClass(T.self, fromJSONDictionary: fromJSONDictionary, error: &error) as? T
    //        return (model, error)
    //    }
    //
    //    class func modelOfClass<T: MTLModel>(T.Type, fromJSONDictionary: [String: AnyObject]?) -> T? {
    //
    //        let model = modelOfClass(T.self, fromJSONDictionary: fromJSONDictionary, error: nil) as? T
    //        return model
    //    }
    //
    //    class func modelsOfClass<T: MTLModel>(T.Type, fromJSONArray: [AnyObject]!) -> ([T]?, NSError?) {
    //        var error: NSError?
    //        let models = modelsOfClass(T.self, fromJSONArray: fromJSONArray, error: &error)
    //        return (models as? [T], error)
    //    }
}


