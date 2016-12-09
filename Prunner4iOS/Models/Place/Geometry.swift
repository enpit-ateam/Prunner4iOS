//
//  Geometry.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/16.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Geometry: Mappable {
  public var location: Location!
  
  public init?(map: Map) {
  }
  
  public mutating func mapping(map: Map) {
    self.location <- map["location"]
  }
}
