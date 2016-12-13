//
//  HistoryService.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation

class HistoryService {
  private static let userDefaults = UserDefaults.standard
  
  private static var histories: Histories = []
  private static var forTestHistories: Histories = [
    History(date: Date(),
      route: nil,
      distance: 114.5141919,
      time: 10000),
  ]
  
  class func getHistories() -> Histories {
    userDefaults.register(defaults: ["DataStore": "default"])
    let storedData:Data? = userDefaults.object(forKey: "History") as! Data?
    guard storedData != nil else{
      return forTestHistories
    }
    guard let hs = NSKeyedUnarchiver.unarchiveObject(with: storedData as Data!) as! Histories? else {
      return forTestHistories
    }
    histories = hs
    return histories
  }
  
  class func getHistories(date: Date) -> Histories {
    let histories_ = getHistories()
    let calendar = Calendar.current
    return histories.filter({(h:History) -> Bool in calendar.isDate(date, equalTo: h.date!, toGranularity: .month)})
  }
  
  class func addHistories(history: History){
    userDefaults.register(defaults: ["DataStore": "default"])
    histories = self.getHistories()
    histories.append(history)
    saveHistories();
  }
  
  private class func saveHistories(){
    userDefaults.register(defaults: ["DataStore": "default"])
    userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: histories), forKey: "History")
    userDefaults.synchronize()
  }
}
