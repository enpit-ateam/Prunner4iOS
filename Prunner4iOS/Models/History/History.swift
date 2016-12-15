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
  public var start: Location?
  public var end: Location?
  
  public init(
    date: Date?,
    route: Route?,
    distance: Double?,
    time: Int?,
    start: Location?,
    end: Location?,
    placeName: String?
  ) {
    self.date = date
    self.route = route
    self.distance = distance
    self.time = time
    self.start = start
    self.end = end
    self.placeName = placeName
  }
  
  static public func == (lhs: History, rhs: History) -> Bool {
    let left = lhs
    let right = rhs
    let lComponent = DayService.getComponent(date: left.date!)
    let rComponent = DayService.getComponent(date: right.date!)
    //[.year, .month, .day, .hour, .minute, .second]
    return lComponent.year == rComponent.year &&
      lComponent.month == rComponent.month &&
      lComponent.day == rComponent.day &&
      lComponent.hour == rComponent.hour &&
      lComponent.minute == rComponent.minute &&
      lComponent.second == rComponent.second
  }
  
  static public func != (lhs: History, rhs: History) -> Bool {
    let left = lhs
    let right = rhs
    let lComponent = DayService.getComponent(date: left.date!)
    let rComponent = DayService.getComponent(date: right.date!)
    //[.year, .month, .day, .hour, .minute, .second]
    return lComponent.year != rComponent.year &&
      lComponent.month != rComponent.month &&
      lComponent.day != rComponent.day &&
      lComponent.hour != rComponent.hour &&
      lComponent.minute != rComponent.minute &&
      lComponent.second != rComponent.second
  }
  
  required convenience public init(coder aDecoder: NSCoder) {
    let date      = aDecoder.decodeObject(forKey: "date") as! Date?
    let route     = aDecoder.decodeObject(forKey: "route") as! Route?
    let distance  = aDecoder.decodeObject(forKey: "distance") as! Double?
    let time      = aDecoder.decodeObject(forKey: "time") as! Int?
    let start     = aDecoder.decodeObject(forKey: "start") as! Location?
    let end       = aDecoder.decodeObject(forKey: "end") as! Location?
    let placeName = aDecoder.decodeObject(forKey: "placeName") as! String?
    
    self.init(
      date: date,
      route: route,
      distance: distance,
      time: time,
      start: start,
      end: end,
      placeName: placeName
    )
  }
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(date, forKey: "date")
    aCoder.encode(route, forKey: "route")
    aCoder.encode(distance, forKey: "distance")
    aCoder.encode(time, forKey: "time")
    aCoder.encode(start, forKey: "start")
    aCoder.encode(end, forKey: "end")
    aCoder.encode(placeName, forKey: "placeName")
  }
  
  public func runStart() -> Location? {
    return route?.legs[0].startLocation
  }
  
  public func runEnd() -> Location? {
    return route?.legs.last?.endLocation
  }

}
