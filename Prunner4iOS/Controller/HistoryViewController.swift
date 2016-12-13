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

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var history_table: Histories = []
  var graph: Graph = Graph(frame: CGRect(x:0, y:135.0, width:400, height:200.0))
  
  var thisDay = Date()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    graph = Graph(frame: CGRect(x:0, y:135.0, width:400, height:200.0))
    
    //HistoryService から データを読み込み、ボタンを生成
    history_table = HistoryService.getHistories()
    graph.setLabel(
      xLabel: DayService.getMonthOfDayList(date: thisDay).map({(d:Int) -> String in d.description}),
      yLabel: DayService.getDistanceTable(historyTable: history_table).map({(distance: Double) -> CGFloat in return CGFloat(distance)})
    )
      
    tableView.delegate = self
    tableView.dataSource = self
    
    self.view.addSubview(graph)
    graph.setNeedsDisplay()
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
    performSegue(withIdentifier: "DETAIL", sender: indexPath)
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
}
