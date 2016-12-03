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
    guard let hs = userDefaults.object(forKey: "History") as! Histories? else {
      return [
        History(date: Date(),
                route: nil,
                distance: 114.5141919,
                time: 10000),
        History(date: Date(),
                route: nil,
                distance: 314.159265,
                time: 10000)
      ]
    }
    histories = hs
    return histories
  }
  
  class func addHistories(history: History){
    guard var hs = userDefaults.object(forKey: "History") as! Histories? else {
      return
    }
    hs.append(history)
    histories = hs
    saveHistories();
  }
  
  private class func saveHistories(){
    userDefaults.set(histories, forKey: "History")
  }
}
