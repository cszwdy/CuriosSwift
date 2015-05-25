//
//  UserModel.swift
//  CuriosSwift
//
//  Created by Emiaostein on 5/25/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import Foundation

class UserModel: Model {
    
    var nikename = "Default nike name"
    var userID = ""
    var descri = ""
    var password = ""
    var iconURL = ""
    var sex = ""
    var email = ""
    var phone = ""
    var areacodeID = ""
    var countryID = ""
    var provinceID = ""
    var cityID = ""
    var weixin = ""
    var weibo = ""
    var ip = ""
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        
        return [
            "descri" : "description"
        ]
    }
}