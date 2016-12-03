//
//  HistoryService.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation

class HistoryService {
  //Historiesの入手と管理
  class func getHistories() -> Histories{
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
}
