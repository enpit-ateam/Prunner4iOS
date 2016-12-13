//
//  TabView.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/13.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class TabView: UIView {

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
    let view = Bundle.main.loadNibNamed("TabView", owner: self, options: nil)?.first as! UIView
    self.addSubview(view)
  }

}
