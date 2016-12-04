//
//  Steps.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/15.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
import ObjectMapper

public class Step: NSObject, NSCoding, Mappable {
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
  
  public required init?(
    distance: Distance!,
    duration: Duration!,
    endLocation: Location!,
    startLocation: Location!
    ){
    self.distance = distance
    self.duration = duration
    self.endLocation = endLocation
    self.startLocation = startLocation
  }
  
  required convenience public init?(coder aDecoder: NSCoder) {
    let distance = aDecoder.decodeObject(forKey: "distance") as! Distance!
    let duration = aDecoder.decodeObject(forKey: "duration") as! Duration!
    let endLocation = aDecoder.decodeObject(forKey: "endLocation") as! Location!
    let startLocation = aDecoder.decodeObject(forKey: "startLocation") as! Location!
    
    self.init(
      distance: distance,
      duration: duration,
      endLocation: endLocation,
      startLocation: startLocation
    )
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(distance, forKey: "distance")
    aCoder.encode(duration, forKey: "duration")
    aCoder.encode(endLocation, forKey: "endLocation")
    aCoder.encode(startLocation, forKey: "duration")
  }
}
