//
//  UserState.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreLocation

class UserState {
  public var current: Location?
  public var distance: Double?
  public var runTime: Int?
  
  public func isReady() -> Bool {
    if current == nil {
      return false
    }
    if distance == nil {
      return false
    }
    return true
  }
  
  public func setDistance(text: String?) {
    if text == nil {
      return
    } else if Int(text!) == nil {
      return
    }
    distance = NSString(string: text!).doubleValue
  }
  
  public func setRunTime(start: Date?, end: Date?) {
    if let st = start, let en = end {
      runTime = Int(en.timeIntervalSince(st))
    }
  }
  
  public func putRunTimeResult() -> String {
    return String(runTime!)
  }
  
  private init() {}
  static let sharedInstance = UserState()
}
