//
//  SlideSwitchViewController.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/12/14.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class SlideSwitchViewController: UIViewController, SlideSwitchViewDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()

      let myBoundSize: CGSize = UIScreen.main.bounds.size
      let tabHeight:CGFloat = 130.0
      let rect = CGRect(x: 0.0, y: myBoundSize.height-tabHeight, width: myBoundSize.width, height: tabHeight)
      let view = SlideSwitchView(frame: rect)
      view.baseColorHex = "71e9ce"
      view.arrowRadius = 10
      view.backgroundColor = UIColor.clear
      view.delegate = self
      self.view.addSubview(view)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func onSwitched() {
    print("hoge")
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
