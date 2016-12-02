//
//  HistoryService.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation

class HistoryService {
  var histories: [History];
  private var index:Int = 0;
  
  init?() {
    self.histories = []
  }
  
  func addHistory(history : History){
    self.histories.append(history);
  }
  
  func next() -> History? {
    guard index <= self.histories.count else {
      return nil;
    }
    let ans:History = self.histories[index];
    index += 1
    return ans
  }
}
