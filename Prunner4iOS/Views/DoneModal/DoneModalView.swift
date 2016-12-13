//
//  DoneModalView.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/13.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class DoneModalView: UIView {
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
  private var v: UIView?
  
  required init?(coder aDecoder: NSCoder) {
    // for using CustonView in storyboard
    super.init(coder: aDecoder)
    commonInit()
  }
  
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    commonInit()
  }
  
  override init(frame: CGRect) {
    // for using CustomView in code
    super.init(frame: frame)
    self.commonInit()
  }
  
  private func commonInit() {
    v = Bundle.main.loadNibNamed(
      "DoneModalView",
      owner: self,
      options: nil
      )?[0] as? UIView
    self.addSubview(v!)
  }
  
  @IBAction func CancelButtonTapped(_ sender: Any) {
    print("cancel button tapped")
  }
  
  @IBAction func didSwiped(_ sender: Any) {
    print("did swaiped")
  }

}
