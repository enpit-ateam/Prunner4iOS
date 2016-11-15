//
//  Steps.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/15.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public class Step: Mappable {
  public var distance: Distance!
  public var duration: Duration!
  public var endLocation: Location!
  public var startLocation: Location!
  
  public required init?(map: Map) {
  }
  
  public func mapping(map: Map) {
    self.distance <- map["distance"]
    self.duration <- map["total_seconds"]
    self.endLocation <- map["end_location"]
    self.startLocation <- map["start_location"]
  }
}
