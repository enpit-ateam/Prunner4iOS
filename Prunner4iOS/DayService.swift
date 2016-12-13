//
//  DayService.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/13.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation
class DayService {
  class public func getDistanceTable(historyTable: [History]) -> [Double]{
    var dayDistances:[Int: [Double]] = [0:[0]]
    for h in historyTable {
      let hDay = getComponent(date: h.date!).day!
      if dayDistances[hDay] != nil {
        dayDistances[hDay]!.append(h.distance!)
      }
      else {
        dayDistances[hDay] = [h.distance!]
      }
    }
    
    var ansTable:[Double] = [0]
    for key in 1...getMaxDay(date: historyTable[0].date!)! {
      if dayDistances[key] == nil || dayDistances[key]!.count == 0 {
        ansTable.append(0)
        continue
      }
      ansTable.append(dayDistances[key]!.reduce(0, {(acc:Double, d:Double) -> Double in return acc + d}) / Double(dayDistances[key]!.count))
    }
    
    return ansTable
  }
  
  class public func getMonthOfDayList(date: Date) -> [Int] {
    if getMaxDay(date: date) == nil {
      return []
    }
    return Array((1...getMaxDay(date: date)!))
  }
  
  class public func getMaxDay(date: Date) -> Int? {
    let maxDays = [31,isReapYear(date: date) ? 29 : 28, 31, 30, 31, 30, 31, 31, 31, 31, 30, 31]
    if (getComponent(date: date).month == nil) {
      return nil
    }

    return maxDays[getComponent(date: date).month! - 1]
  }
  
  class private func isReapYear(date: Date) -> Bool {
    let component = getComponent(date: date)
    if component.year! % 4 != 0{
      return false
    }
    if component.year! % 100 != 0{
      return true
    }
    return false
  }
  
  class private func getComponent(date: Date) -> DateComponents {
    let calendar = Calendar.current
    let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    return component
  }
}
