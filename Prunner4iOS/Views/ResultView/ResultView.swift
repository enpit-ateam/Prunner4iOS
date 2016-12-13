//
//  ResultView.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/14.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class ResultView: UIView {
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
  private var v: UIView?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    v = Bundle.main.loadNibNamed(
      "ResultView",
      owner: self,
      options: nil
      )?[0] as? UIView
    self.addSubview(v!)
  }
  
}
