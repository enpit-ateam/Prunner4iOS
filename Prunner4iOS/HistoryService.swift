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
  
  class func getHistories() -> Histories{
    userDefaults.register(defaults: ["DataStore": "default"])
    let storedData:Data? = userDefaults.object(forKey: "History") as! Data?
    guard storedData != nil else{
      return [
        History(date: Date(),
                //route: nil,
          distance: 114.5141919,
          time: 10000),
        History(date: Date(),
                //route: nil,
          distance: 314.159265,
          time: 10000)
      ]
    }
    guard let hs = NSKeyedUnarchiver.unarchiveObject(with: storedData as! Data!) as! Histories? else {
      return [
        History(date: Date(),
                //route: nil,
                distance: 114.5141919,
                time: 10000),
        History(date: Date(),
                //route: nil,
                distance: 314.159265,
                time: 10000)
      ]
    }
    histories = hs
    return histories
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
