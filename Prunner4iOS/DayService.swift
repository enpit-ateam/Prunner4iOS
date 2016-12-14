//
//  DayService.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/13.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation

enum HistoryDataMode {
  case Distance
  case Time
  case Pace
}

class DayService {
  class public func changeMonth(date: Date, month: Int) -> Date {
    let calendar = Calendar.current
    return calendar.date(bySetting: .month, value: month, of: date)!
  }
  //getDistanceTable(date: Date, historyTable: [History])
  class public func getDistanceTable(date: Date, historyTable: [History], type: HistoryDataMode) -> [Double]{
    var dayDatas:[Int: [Double]] = [0:[0]]
    switch type {
    case .Distance:
      for h in historyTable {
        let hDay = getComponent(date: h.date!).day!
        if dayDatas[hDay] != nil {
          dayDatas[hDay]!.append(h.distance!)
        }
        else {
          dayDatas[hDay] = [h.distance!]
        }
      }
      var ansTable:[Double] = []
      for key in 0...getMaxDay(date: date)! {
        if dayDatas[key] == nil || dayDatas[key]!.count == 0 {
          ansTable.append(0)
          continue
        }
        ansTable.append(dayDatas[key]!.reduce(0, {(acc:Double, d:Double) -> Double in return acc + d}) / Double(dayDatas[key]!.count))
      }
      
      return ansTable

    case .Time:
      for h in historyTable {
        let hDay = getComponent(date: h.date!).day!
        if dayDatas[hDay] != nil {
          dayDatas[hDay]!.append(Double(h.time!))
        }
        else {
          dayDatas[hDay] = [Double(h.time!)]
        }
      }
      var ansTable:[Double] = []
      for key in 0...getMaxDay(date: date)! {
        if dayDatas[key] == nil || dayDatas[key]!.count == 0 {
          ansTable.append(0)
          continue
        }
        ansTable.append(dayDatas[key]!.reduce(0, {(acc:Double, d:Double) -> Double in return acc + d}))
      }
      
      return ansTable
    case .Pace:
      for h in historyTable {
        let hDay = getComponent(date: h.date!).day!
        if dayDatas[hDay] != nil {
          dayDatas[hDay]!.append(h.distance! / Double(h.time!))
        }
        else {
          dayDatas[hDay] = [h.distance! / Double(h.time! == 0 ? 1 : h.time!)]
        }
      }
      var ansTable:[Double] = []
      for key in 0...getMaxDay(date: date)! {
        if dayDatas[key] == nil || dayDatas[key]!.count == 0 {
          ansTable.append(0)
          continue
        }
        ansTable.append(dayDatas[key]!.reduce(0, {(acc:Double, d:Double) -> Double in return acc + d}) / Double(dayDatas[key]!.count))
      }
      
      return ansTable
    }
    
//    var ansTable:[Double] = []
//    for key in 0...getMaxDay(date: date)! {
//      if dayDatas[key] == nil || dayDatas[key]!.count == 0 {
//        ansTable.append(0)
//        continue
//      }
//      ansTable.append(dayDatas[key]!.reduce(0, {(acc:Double, d:Double) -> Double in return acc + d}) / Double(dayDatas[key]!.count))
//    }
//
//    return ansTable
  }
  
  class public func getMonthOfDayList(date: Date) -> [Int] {
    if getMaxDay(date: date) == nil {
      return []
    }
    return Array((0...getMaxDay(date: date)!))
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
  
  class public func getComponent(date: Date) -> DateComponents {
    let calendar = Calendar.current
    let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    return component
  }
}
