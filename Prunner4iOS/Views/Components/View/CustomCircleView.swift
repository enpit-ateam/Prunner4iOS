//
//  CustomCircleView.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/13.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

// 角丸と枠線を追加したカスタムUIView
@IBDesignable
class CustomCircleView: UIView {
  
  @IBInspectable public var borderColor: UIColor = UIColor.clear {
    didSet {
      self.layer.borderColor = borderColor.cgColor
    }
  }
  
  @IBInspectable public var borderWidth: CGFloat = 0 {
    didSet {
      self.layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable public var cornerRadius: CGFloat = 0 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
}
