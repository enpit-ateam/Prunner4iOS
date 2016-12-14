//
//  TabSelectView.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/12/14.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

extension UIColor {
  class func hexStr ( hexStr : NSString, alpha : CGFloat) -> UIColor {
    var hexStr = hexStr
    let alpha = alpha
    hexStr = hexStr.replacingOccurrences(of: "#", with: "") as NSString
    let scanner = Scanner(string: hexStr as String)
    var color: UInt32 = 0
    if scanner.scanHexInt32(&color) {
      let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
      let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
      let b = CGFloat(color & 0x0000FF) / 255.0
      return UIColor(red:r,green:g,blue:b,alpha:alpha)
    } else {
      print("invalid hex string")
      return UIColor.white
    }
  }
}

class RouteSelectElement {
  var title = ""
  var placeName = ""
  var distance = ""
  
  init(title: String, placeName: String, distance: String) {
    self.title = title
    self.placeName = placeName
    self.distance = distance
  }
}

protocol TabSelectViewDelegate {
  func onSelectorChanged(index: Int)
}

class TabSelectView: UIView {
  
  var delegate:TabSelectViewDelegate?

  private var _titleHeight = 25
  private var _selector = 0
  
  var tabStore: [RouteSelectElement]?
  
  var titleHeight:Int {
    get{
      return self._titleHeight
    }
    set(value){
      _titleHeight = value
      self.setNeedsDisplay()
    }
  }
  
  var tabWidth:Int {
    get{
      return Int(self.bounds.size.width)
    }
  }
  
  var tabHeight:Int {
    get{
      return Int(self.bounds.size.height)
    }
  }
  
  var tabNum:Int {
    get{
      return tabStore!.count
    }
  }
  
  var titleWidth:Int {
    get{
      return Int(tabWidth / tabNum) - titleHeight
    }
  }
  
  override init(frame: CGRect){
    self.tabStore = [RouteSelectElement]()
    super.init(frame: frame)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapped(gestureRecognizer:)))
    self.addGestureRecognizer(tapGestureRecognizer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var selector:Int {
    get{
      return self._selector
    }
    set(value){
      _selector = value
      self.setNeedsDisplay()
    }
  }
  
  func onTapped(gestureRecognizer: UITapGestureRecognizer) {
    if (gestureRecognizer.state == UIGestureRecognizerState.ended)
    {
      let tapPoint = gestureRecognizer.location(in: self)
      let current = selector
      selector = (tapPoint.y > 0 && tapPoint.y < CGFloat(titleHeight)) ? Int(tapPoint.x)/(titleWidth+titleHeight) : selector
      if current != selector {
        delegate?.onSelectorChanged(index: selector)
      }
    }
  }
  
  private func tab(index: Int) {
    //形の描画
    let start = index * (titleWidth + titleHeight)
    let line = UIBezierPath()
    line.move(to: CGPoint(x:0, y:titleHeight))
    line.addLine(to: CGPoint(x:start, y:titleHeight))
    line.addLine(to: CGPoint(x:start+titleHeight, y:0))
    line.addLine(to: CGPoint(x:start+titleWidth, y:0))
    line.addLine(to: CGPoint(x:start+titleWidth+titleHeight, y:titleHeight))
    line.addLine(to: CGPoint(x:start+tabWidth, y:titleHeight))
    line.addLine(to: CGPoint(x:start+tabWidth, y:tabHeight))
    line.addLine(to: CGPoint(x:0, y:tabHeight))
    line.addLine(to: CGPoint(x:0, y:titleHeight))
    if index == selector {
      UIColor.hexStr(hexStr: "e8f8ff", alpha: 1).setFill()
    } else {
      UIColor.hexStr(hexStr: "b4dced", alpha: 1).setFill()
    }
    line.fill()
    
    //文字の描画
    var strSize = 20
    var att = [
      NSFontAttributeName: UIFont(name: "HiraginoSans-W0", size: CGFloat(strSize))!,
      NSForegroundColorAttributeName: UIColor.hexStr(hexStr: "4a4a4a", alpha: 1)
    ]
    NSString(string: tabStore![index].title).draw(at: CGPoint(x: start+titleHeight, y: (titleHeight-strSize)/2), withAttributes: att)
    strSize = 20
    att[NSFontAttributeName] = UIFont(name: "HiraginoSans-W0", size: CGFloat(strSize))!
    NSString(string: tabStore![index].placeName).draw(at: CGPoint(x: titleHeight/2, y: tabHeight/2 - strSize), withAttributes: att)
    strSize = 40
    att[NSFontAttributeName] = UIFont(name: "HiraginoSans-W0", size: CGFloat(strSize))!
    NSString(string: tabStore![index].distance).draw(at: CGPoint(x: titleHeight + tabWidth - 200, y: tabHeight-strSize-10), withAttributes: att)
    strSize = 25
    att[NSFontAttributeName] = UIFont(name: "HiraginoSans-W0", size: CGFloat(strSize))!
    NSString(string: "km").draw(at: CGPoint(x: titleHeight + tabWidth - 70, y: tabHeight-strSize-10), withAttributes: att)
  }
  
  override func draw(_ rect: CGRect) {
    //some code to change self properties
    //title draw
    if tabStore == nil {
      return
    }
    
    //for i in stride(from:tabNum!-1, to: -1, by: -1) {
    for i in stride(from:0, to: tabStore!.count, by: 1) {
      if i == selector {
        continue
      }
      tab(index: i)
    }
    tab(index: selector)
  }
}
