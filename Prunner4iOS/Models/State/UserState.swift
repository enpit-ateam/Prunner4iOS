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
  public var startDate: Date?
  public var endDate: Date?
  public var route: Route?
  
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
    } else if !isNumber(str: text!) {
      return
    }
    var _dist = NSString(string: text!).doubleValue
    if _dist < 100 {
      // kmであると考えて * 1000する
      _dist = _dist * 1000
    }
    distance = _dist
  }
  
  private func isNumber(str: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: "^[0-9]+[.]?[0-9]*$", options: NSRegularExpression.Options())
    let matches = regex.numberOfMatches(in: str, options: [], range: NSMakeRange(0, str.characters.count))
    return matches > 0
  }
  
  public func calcRunTime() -> Int? {
    if let st = self.startDate, let en = self.endDate {
      return Int(en.timeIntervalSince(st))
    }
    return nil
  }

  public func initialize() {
    // self.current do not reset!!
    distance = nil
    startDate = nil
    endDate = nil
    route = nil
  }

  private init() {}
  static let sharedInstance = UserState()
}
