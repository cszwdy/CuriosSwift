//
//  ImageTokenRequest.swift
//  
//
//  Created by Emiaostein on 7/6/15.
//
//

import UIKit

class ImageTokenRequest: BaseRequst {
   
    class func requestWith(aJsonParameter: String?, aResult: Result) -> BaseRequst {
        
        return requestWithComponents(["upload/publishUptoken"], aJsonParameter: aJsonParameter, aResult: aResult)
    }
}
