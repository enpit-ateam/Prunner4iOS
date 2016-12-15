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
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var navBar: UINavigationItem!
  @IBOutlet weak var graph: Graph!

  var history_table: Histories = []
  
  var thisDate: Date!
  var thisYear: Int = 2016
  var thisMonth: Int = 12
  var currentType:HistoryDataMode = .Distance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // TableCellの登録
    self.tableView.register(UINib(nibName: "TableView", bundle: nil), forCellReuseIdentifier: "historyCell")
    
    history_table = HistoryService.getHistories()
    
    thisDate = Date()
    //thisDate = changeMonth(date: thisDate, month:12)
    
    // set delegate
    graph.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // 再描画
    drawGraph(graph: graph, date: thisDate, type: currentType)
    self.tableView.reloadData()
    super.viewWillAppear(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される）
  func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! TableView!
    cell?.setCell(history: history_table[indexPath.row])
    return cell!
  }
  
  //データの個数を返すメソッド
  func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
    return history_table.count
  }
  
  // Index目のCellをタッチしたとき
  func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
    // Cellを触るとDetailに遷移する
    // TODO:
    // 遷移を矢印のみに変更する
    graph.selectedDay = DayService.getComponent(date: history_table[indexPath.row].date!).day!
    graph.setNeedsDisplay()
    //performSegue(withIdentifier: "DETAIL", sender: indexPath)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DETAIL" {
      let vc = segue.destination as! DetailViewController
      let index = sender as? IndexPath
      vc.history = history_table[index!.row]
    }
  }
  
  @IBAction func backButtonTouched(_ sender: Any) {
    thisMonth = thisMonth - 1
    if thisMonth < 1 {
      thisMonth = 12
      thisYear = thisYear - 1
    }
    thisDate = changeMonth(date: thisDate, month: thisMonth)
    thisDate = changeYear(date: thisDate, year: thisYear)
    navBar.title = getTitle(date: thisDate)
    self.history_table = HistoryService.getHistories(month: self.thisDate)
    drawGraph(graph: graph, date: thisDate, type: currentType)
    self.tableView.reloadData()
    super.viewWillAppear(true)
  }
  
  @IBAction func nextButtonTouched(_ sender: Any) {
    thisMonth = thisMonth + 1
    if thisMonth > 12 {
      thisMonth = 1
      thisYear = thisYear + 1
    }
    thisDate = changeMonth(date: thisDate, month: thisMonth)
    thisDate = changeYear(date: thisDate, year: thisYear)
    navBar.title = getTitle(date: thisDate)
    self.history_table = HistoryService.getHistories(month: self.thisDate)
    drawGraph(graph: graph, date: thisDate, type: currentType)
    self.tableView.reloadData()
    super.viewWillAppear(true)
  }
  
  @IBAction func nextGraphButton(_ sender: Any) {
    if pageControl.currentPage + 1 <= pageControl.numberOfPages - 1{
      pageControl.currentPage = pageControl.currentPage + 1
      changePage(page: pageControl.currentPage)
    }
  }
  
  @IBAction func backGraphButton(_ sender: Any) {
    if pageControl.currentPage - 1 >= 0{
      pageControl.currentPage = pageControl.currentPage - 1
      changePage(page: pageControl.currentPage)
    }
    
  }
  
  @IBAction func changePage(_ sender: UIPageControl) {
    changePage(page: sender.currentPage)
  }
  
  private func changePage(page: Int) {
    switch page {
    case 0:
      drawGraph(graph: graph, date: thisDate, type: HistoryDataMode.Distance)
    case 1:
      drawGraph(graph: graph, date: thisDate, type: HistoryDataMode.Time)
    case 2:
      drawGraph(graph: graph, date: thisDate, type: HistoryDataMode.Pace)
    default:
      break
    }
  }
  
  private func makeCellText(history:History) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    let dateText:String = formatter.string(from: history.date!)
    let distanceText:String = history.distance!.description
    let cellText:String = String(format: "%@     %@", arguments: [dateText, distanceText]) //ここのデザインは暫定
    
    return cellText
  }
  
  private func drawGraph(graph: Graph, date: Date, type: HistoryDataMode) {
    let xLabel = DayService.getMonthOfDayList(date: date).map({(d:Int) -> String in d.description})
    var yLabel =
      DayService.getDistanceTable(
        date: date,
        historyTable: HistoryService.getHistories(month: date),
        type: type
        )
        .map({(distance: Double) -> CGFloat in return CGFloat(distance)})
    switch type{
    case .Distance:
      break
    case .Time:
      yLabel =
        DayService.getDistanceTable(
          date: date,
          historyTable: HistoryService.getHistories(month: date),
          type: type
        )
        .map({(time: Double) -> CGFloat in return CGFloat(time)})
    case .Pace:
      yLabel =
        DayService.getDistanceTable(
          date: date,
          historyTable: HistoryService.getHistories(month: date),
          type: type
        )
        .map({(pace: Double) -> CGFloat in return CGFloat(pace)})
    }
    
    graph.setLabel(
      xLabel: xLabel,
      yLabel: yLabel
    )
    graph.setDate(date: thisDate)
    graph.setNeedsDisplay()
  }
  
  
  //DayServiceに移す
  private func changeYear(date: Date, year: Int) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
    return calendar.date(from: DateComponents(year: year, month: components.month, day: components.day ))!
  }
  
  private func changeMonth(date: Date, month: Int) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
    return calendar.date(from: DateComponents(year: components.year, month: month, day: components.day ))!
  }
  
  private func changeDay(date: Date, day: Int) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
    components.day = day + 1
    components.hour = -15
    return calendar.date(from: components)!
  }
  
  public func pointTaped(selectedDay: Int) {
  }
  
  private func getTitle(date: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM"
    
    let dateText:String = formatter.string(from: date)
    
    return dateText
  }
  
  @IBAction func backToHistory(_ segue: UIStoryboardSegue) {}
}
