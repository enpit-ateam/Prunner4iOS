//
//  CustomButton.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/05.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }
}
