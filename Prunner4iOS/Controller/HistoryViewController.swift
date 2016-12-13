//
//  HistoryViewController.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation.NSDateFormatter

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGraphViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var history_table: Histories = []
  var graph: Graph = Graph(frame: CGRect(x:0, y:135.0, width:400, height:200.0))
  var thisDate: Date!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    history_table = HistoryService.getHistories()
    
    thisDate = Date()
    graph = Graph(frame: CGRect(x:0, y:135.0, width:400, height:200.0))
    graph.delegate = self
    
    thisDate = changeMonth(date: thisDate, month:12)
    
    drawGraph(graph: graph, date: thisDate)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    self.view.addSubview(graph)
  }
  
  //データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される）
  func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for:indexPath) as UITableViewCell
    
    cell.textLabel?.text = makeCellText(history: history_table[indexPath.row])
    return cell
  }
  
  //データの個数を返すメソッド
  func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
    return history_table.count
  }
  
  func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
    //changeSelected(view:graph, day:history_table[indexPath])
    //performSegue(withIdentifier: "DETAIL", sender: indexPath)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DETAIL" {
      let vc = segue.destination as! DetailViewController
      let index = sender as? IndexPath
      vc.history = history_table[index!.row]
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func makeCellText(history:History) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    let dateText:String = formatter.string(from: history.date!)
    let distanceText:String = history.distance!.description
    let cellText:String = String(format: "%@     %@", arguments: [dateText, distanceText]) //ここのデザインは暫定
    
    return cellText
  }
  
  private func drawGraph(graph: Graph, date: Date) {
    history_table = HistoryService.getHistories(date: date)
    var xLabel = DayService.getMonthOfDayList(date: date).map({(d:Int) -> String in d.description})
    var yLabel = DayService.getDistanceTable(date: date, historyTable: HistoryService.getHistories()).map({(distance: Double) -> CGFloat in return CGFloat(distance)})
    
    graph.setLabel(
      xLabel: xLabel,
      yLabel: yLabel
    )
    graph.setNeedsDisplay()
  }
  
  private func changeMonth(date: Date, month: Int) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
    components.month = month
    return calendar.date(from: components)!
  }
  
  private func changeDay(date: Date, day: Int) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
    components.day = day
    return calendar.date(from: components)!
  }
  
  public func pointTaped(selectedDay: Int) {
    self.thisDate = changeDay(date: self.thisDate, day: selectedDay)
    self.history_table = HistoryService.getHistories(date: self.thisDate)
    self.tableView.reloadData()
    super.viewWillAppear(true)
  }
}
