//
//  Locations.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/15.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public class Location: Mappable {
  public var lat: Double!
  public var lng: Double!
  
  required public init?(map: Map) {
  }
  
  public func mapping(map: Map) {
    self.lat <- map["lat"]
    self.lng <- map["lng"]
  }
}