//
//  SliderSwitchView.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/12/14.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

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

protocol SlideSwitchViewDelegate {
  func onSwitched()
}

class SlideSwitchView: UIView {
  
  private var _controllerRadius = 120
  private var _margin = 10
  private var _baseColorHex = "71e9ce"
  private var _controllerPoint:CGPoint?
  private var _arrowRadius:CGFloat = 5.0
  
  var delegate: SlideSwitchViewDelegate?
  
  var controllerPoint:CGPoint {
    get {
      return _controllerPoint!
    }
    set(newPoint) {
      _controllerPoint = newPoint
      self.setNeedsDisplay()
    }
  }
  
  var controllerRadius:CGFloat {
    get {
      return CGFloat(_controllerRadius)
    }
  }
  
  var margin:CGFloat {
    get {
      return CGFloat(_margin)
    }
  }
  
  var baseColorHex:String {
    get {
      return _baseColorHex
    }
    set(hex) {
      _baseColorHex = hex
    }
  }
  
  var arrowRadius:CGFloat {
    get {
      return _arrowRadius
    }
    set(newRadius) {
      _arrowRadius = newRadius
    }
  }
  
  private var controllerInitPosition:CGPoint {
    get {
      return CGPoint(x:controllerRadius/2+margin, y: bounds.height/2)
    }
  }
  
  override init(frame: CGRect){
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    commonInit()
  }
  
  public func commonInit() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanned(gestureRecognizer:)))
    self.addGestureRecognizer(panGestureRecognizer)
    controllerPoint = controllerInitPosition
  }
  
  func onPanned(gestureRecognizer: UIPanGestureRecognizer) {
    let tappedPoint: CGPoint = gestureRecognizer.location(in: self)
    if gestureRecognizer.state == UIGestureRecognizerState.ended {
      controllerPoint = controllerInitPosition
    }
    if tappedPoint.x < controllerPoint.x + controllerRadius && controllerPoint.x - controllerRadius < tappedPoint.x && tappedPoint.y < controllerPoint.y + controllerRadius && controllerPoint.y - controllerRadius < tappedPoint.y {
      let endPoint = bounds.width-controllerRadius/2-margin
      let newpoint: CGPoint = gestureRecognizer.translation(in: self)
      controllerPoint.x = (newpoint.x + controllerRadius/2 <= endPoint) ? newpoint.x + controllerRadius/2 : controllerPoint.x
      print(controllerPoint.x)
      print(endPoint)
      if controllerPoint.x >= endPoint - arrowRadius {
        delegate?.onSwitched()
      }
    }
  }
  
  private func circle(center: CGPoint, radius:CGFloat, arcWidth: CGFloat)->UIBezierPath {
    let path = UIBezierPath(arcCenter: center,
                            radius: radius/2 - arcWidth/2,
                            startAngle: CGFloat(0),
                            endAngle: CGFloat(2.0*M_PI),
                            clockwise: true)
    path.lineWidth = radius - arcWidth
    return path
  }
  
  override func draw(_ rect: CGRect) {
    
    //controller
    let arcWidth:CGFloat = 10
    let controllerPath = circle(center: controllerPoint,
                                radius: controllerRadius,
                                arcWidth: arcWidth)
    controllerPath.lineWidth = controllerRadius - arcWidth
    UIColor.hexStr(hexStr: baseColorHex as NSString, alpha: 1).setFill()
    controllerPath.fill()
    
    //vector
    let alpha = (bounds.width-controllerRadius-2*margin-(controllerPoint.x-(controllerRadius/2+margin)))/(bounds.width-controllerRadius-2*margin)
    let vector = UIBezierPath()
    let start = controllerInitPosition.x + margin + (controllerRadius + arcWidth)/2
    let end = bounds.width - start
    vector.move(to: CGPoint(x: start, y: bounds.height/2))
    vector.addLine(to: CGPoint(x: end, y: bounds.height/2))
    vector.addLine(to: CGPoint(x: end - 10, y: bounds.height/2 - 10))
    vector.move(to: CGPoint(x: end, y: bounds.height/2 ))
    vector.addLine(to: CGPoint(x: end - 10, y: bounds.height/2 + 10))
    vector.lineWidth = 5
    UIColor.hexStr(hexStr: baseColorHex as NSString, alpha: alpha).setStroke()
    vector.stroke()
    
    //endPoint
    let endPointPath = circle(center: CGPoint(x:bounds.width-controllerInitPosition.x, y: bounds.height/2),
                              radius: (controllerRadius/4)/alpha,
                              arcWidth: arcWidth)
    endPointPath.lineWidth = 20
    UIColor.hexStr(hexStr: baseColorHex as NSString, alpha: alpha).setStroke()
    endPointPath.stroke()
  }
}
