//
//  TableView.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/14.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class TableView: UITableViewCell {
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
  // Labels
  
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var runTimeLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  
  func setCell(history: History) {
    let distance: Double = history.distance! / 1000.0
    let time: Int = history.time!
    let hour: Int = time / (60 * 60)
    let minute: Int = (time % (60 * 60)) / 60
    let pace: Int = Int(distance / Double((time == 0 ? 1 : time)))
    let startDate = history.date!
    let day:Int = DayService.getComponent(date: startDate).day!
    dayLabel.text = day.description
    timeLabel.text = String(format: "%2d:%2d", DayService.getComponent(date: startDate).hour!, DayService.getComponent(date: startDate).minute!)
    distanceLabel.text = String(format: "%.1f", distance)
    runTimeLabel.text = String(format: "%d:%2d", hour, minute)
    paceLabel.text = String(format: "%d", pace)
  }
}
