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

class HistoryViewController: UIViewController {
  
  var history_table: Histories = []
  
  override func viewDidLoad() {
    //ToDo:実装 HistoryService から データを読み込み、ボタンを生成
    history_table = HistoryService.getHistories()
    let index: Int = 0;
    
    history_table.forEach({ history in
      let button = self.makeButton(history: history, index: index);
      //ボタンをタップした時に実行するメソッドを指定
      //button.addTarget(self, action: "tapped:", forControlEvents:.TouchUpInside)
      //viewにボタンを追加する
      self.view.addSubview(button)
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func makeButton(history:History, index:Int) -> UIButton{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm Z"
    
    let button_text:String = formatter.string(from: history.date);
    let button = UIButton()
    
    button.setTitle(button_text, for: .normal)
    button.frame = CGRect(x: 0, y: 0, width: 414, height: 50) //ハードコーディングはやめる
    
    button.tag = 1
    button.layer.position = CGPoint(x: 207, y:100) //ハードコーディングはやめる
    button.layer.borderWidth = 1
    
    button.backgroundColor = UIColor.red
    return button;
  }
}
