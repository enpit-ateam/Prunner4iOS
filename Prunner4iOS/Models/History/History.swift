//
//  History.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation

public struct History {
  public var date: Date!
  public var route: Route!
  public var distance: Double!
  public var time: Int!
  
  //for debug remove '?'
  public init(
    date: Date!,
    route: Route?, //for debug add '?'
    distance: Double!,
    time: Int!
  ) {
    self.date = date;
    self.route = route;
    self.distance = distance;
    self.time = time;
  }
}
