//
//  History.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation

public class History: NSObject, NSCoding {
  public var date: Date!
  //public var route: Route!
  public var distance: Double!
  public var time: Int!
  
  //for debug remove '?'
  public init(
    date: Date!,
    //route: Route?, //for debug add '?'
    distance: Double!,
    time: Int!
  ) {
    self.date = date;
    //self.route = route;
    self.distance = distance;
    self.time = time;
  }
  
  required convenience public init(coder aDecoder: NSCoder) {
    let da = aDecoder.decodeObject(forKey: "date") as! Date!
    let di = aDecoder.decodeObject(forKey: "distance") as! Double!
    let t  = aDecoder.decodeObject(forKey: "time") as! Int!
    
    self.init(
      date: da,
      distance: di,
      time: t
    )
  }
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(date, forKey: "date")
    aCoder.encode(distance, forKey: "distance")
    aCoder.encode(time, forKey: "time")
  }

}
