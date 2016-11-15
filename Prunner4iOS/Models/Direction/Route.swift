//
//  Routes.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/09.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Route: Mappable {
  public var leg: Leg!
  
  public init?(map: Map) {
  }
  
  public mutating func mapping(map: Map) {
    self.leg <- map["legs"]
  }
}
