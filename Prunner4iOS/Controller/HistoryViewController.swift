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

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var history_table: Histories = []
    
  override func viewDidLoad() {
    //ToDo:実装 HistoryService から データを読み込み、ボタンを生成
    history_table = HistoryService.getHistories()

    tableView.delegate = self
    tableView.dataSource = self

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
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func makeCellText(history:History) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    let dateText:String = formatter.string(from: history.date)
    let cellText:String = dateText
    
    return cellText
  }
}
