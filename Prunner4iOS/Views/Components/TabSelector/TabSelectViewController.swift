//
//  TabSelectViewController.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/12/14.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class TabSelectViewController: UIViewController, TabSelectViewDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
      
    let myBoundSize: CGSize = UIScreen.main.bounds.size
    let tabHeight:CGFloat = 130.0
    let rect = CGRect(x: 0.0, y: myBoundSize.height-tabHeight, width: myBoundSize.width, height: tabHeight)
    let view = TabSelectView(frame: rect)
    view.tabStore!.append(RouteSelectElement(title: "ルート1", placeName: "イーアスつくば研究学園店", distance: "42.195"))
    view.tabStore!.append(RouteSelectElement(title: "ルート2", placeName: "うんちくん", distance: "42.195"))
    view.tabStore!.append(RouteSelectElement(title: "ルート3", placeName: "毎日ラーメン健康生活", distance: "42.195"))
    view.selector = 0
    view.backgroundColor = UIColor.clear
    view.delegate = self
    
    self.view.addSubview(view)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func onSelectorChanged(index: Int) {
    print(index)
  }
}
