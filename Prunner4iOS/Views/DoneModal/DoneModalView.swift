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

  @IBAction func dismissButtonTapped(_ sender: Any) {
    print("dismiss button tapped")
  }
  
  @IBAction func CancelButtonTapped(_ sender: Any) {
    print("cancel button tapped")
  }
  
  @IBAction func didSwiped(_ sender: Any) {
    print("did swaiped")
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}
