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
  
  // Labels
  @IBOutlet weak var DateLabel: UILabel!
  @IBOutlet weak var DistanceLabel: UILabel!
  @IBOutlet weak var TimesLabel: UILabel!
  @IBOutlet weak var CalorieLabel: UILabel!
  @IBOutlet weak var PaceLabel: UILabel!
  @IBOutlet weak var PlaceNameLabel: UILabel!
  
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
