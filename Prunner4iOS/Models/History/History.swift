//
//  History.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation

public class History: NSObject, NSCoding {
  public var date: Date?
  public var route: Route?
  public var distance: Double?
  public var time: Int?
  public var placeName: String?
  
  public init(
    date: Date?,
    route: Route?,
    distance: Double?,
    time: Int?,
    placeName: String?
  ) {
    self.date = date
    self.route = route
    self.distance = distance
    self.time = time
    self.placeName = placeName
  }
  
  required convenience public init(coder aDecoder: NSCoder) {
    let date      = aDecoder.decodeObject(forKey: "date") as! Date?
    let route     = aDecoder.decodeObject(forKey: "route") as! Route?
    let distance  = aDecoder.decodeObject(forKey: "distance") as! Double?
    let time      = aDecoder.decodeObject(forKey: "time") as! Int?
    let placeName = aDecoder.decodeObject(forKey: "placeName") as! String?
    
    self.init(
      date: date,
      route: route,
      distance: distance,
      time: time,
      placeName: placeName
    )
  }
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(date, forKey: "date")
    aCoder.encode(route, forKey: "route")
    aCoder.encode(distance, forKey: "distance")
    aCoder.encode(time, forKey: "time")
    aCoder.encode(placeName, forKey: "placeName")
  }
  
  public func runStart() -> Location? {
    return route?.legs[0].startLocation
  }
  
  public func runEnd() -> Location? {
    return route?.legs.last?.endLocation
  }

}
