//
//  Routes.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/09.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public class Route: NSObject, NSCoding, Mappable {
  public var legs: [Leg] = []
  
  public required init?(map: Map) {
  }
  
  public func mapping(map: Map) {
    self.legs <- map["legs"]
  }
  
  public required init?(legs: Array<Leg>){
    self.legs = legs
  }
  
  required convenience public init?(coder aDecoder: NSCoder) {
    let legs = aDecoder.decodeObject(forKey: "legs") as! Array<Leg>
    
    self.init(
      legs: legs
    )
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(legs, forKey: "legs")
  }
}
