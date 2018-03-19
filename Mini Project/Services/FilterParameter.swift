//
//  FilterParameter.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit

final class FilterParameter:NSObject {
    var typeShopName:[String] = ["Gold Merchant","Official Store"]
    var selelectedShop:[String] = []
    var q:String!
    var minVal:Float = -1
    var maxVal:Float = -1
    var page:NSNumber = 1
    var wholesale:Bool = false
    var params:[String:Any] = [:]
    
    func getParameter() -> [String:Any] {
        params = [
            "q":q,
            "wholesale":wholesale.description,
            "starts":page,
            "rows":10
        ]
        if minVal >= 0 {
            params.updateValue(Int(minVal), forKey: "pmin")
        }
        if maxVal >= 0 {
            params.updateValue(Int(maxVal), forKey: "pmax")
        }
        
        if selelectedShop.count > 0 {
            var array:[String] = []
            for item in selelectedShop {
                if item == typeShopName[0]{
                    params.updateValue(2, forKey: "fshop")
                }else{
                    params.updateValue("true", forKey: "official")
                }
            }
            
        }
        print(params)
        return params
    }
}
