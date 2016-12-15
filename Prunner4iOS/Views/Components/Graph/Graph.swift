//
//  Graph.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/13.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

protocol UIGraphViewDelegate {
  func pointTaped(selectedDay: Int)
}

@IBDesignable class Graph: UIView {
//  @IBInspectable var counter: Int = 5
//  @IBInspectable var outlineColor: UIColor = UIColor.green
//  @IBInspectable var counterColor: UIColor = UIColor.orange
  
  public var xLabel:[String] = []// = ["10/1", "10/2", "10/3", "10/4", "10/5", "10/6", "10/7", "10/8", "10/9", "10/10", "10/11", "10/12", "10/13", "10/14", "10/15", "10/16", "10/17", "10/18", "10/19", "10/20", "10/21", "10/22", "10/23", "10/24", "10/25", "10/26", "10/27", "10/28", "10/29", "10/30", "10/31"] //Test Data
  public var yLabel:[CGFloat] = []// = [0, 0, 4, 3, 3, 4, 4, 5, 6, 5, 4, 3, 4, 5, 6, 4, 2, 1, 1, 0, 0, 5, 6, 7, 7, 8, 7, 6, 9, 8, 8] //Test Data
  public var type: HistoryDataMode = .Distance
  var delegate: UIGraphViewDelegate!

  var backLineColor:UIColor = UIColor(red:0.972,  green:0.973,  blue:0.972, alpha:1)
  
  var xDialMergin:CGFloat = 30 //目盛り間の距離
  var yDialMergin:CGFloat = 30 //同じ
  let xDialSize:CGFloat = 5 //メモリのサイズ
  let yDialSize:CGFloat = 5 //同じ
  
  var graph:[CGPoint] = []
  //var tappedPoint:CGPoint? = nil
  var texts:[UILabel] = []
  public var selectedDay:Int = 1
  
  var baseLineColor:UIColor = UIColor(red:163/255, green: 170/255, blue:176/255, alpha: 1)
  var lineColor:UIColor = UIColor(red:44/255, green:230/255, blue:205/255, alpha: 1)
  var selectedPointColor:UIColor = UIColor(red:251/255, green:148/255, blue:104/255, alpha: 1)
  
  override required init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  public func commonInit() {
    selectedDay = DayService.getComponent(date: Date()).day!
    backgroundColor = UIColor(red:232/255,  green:248/255,  blue:255/255, alpha:1)
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(Graph.panGraph(sender:)))
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Graph.tapGraph(sender:)))
    self.addGestureRecognizer(panGesture)
    self.addGestureRecognizer(tapGesture)
  }
  
  func panGraph(sender: UIPanGestureRecognizer) {
    let tappedPoint = solveNearestPoint(selectedPoint: sender.location(in: self), points: graph)

    var selectedDay = graph.index(of: tappedPoint)
    if selectedDay == 0 {
      selectedDay = 1
    }
    //self.selectedDay = selectedDay!
    delegate.pointTaped(selectedDay: selectedDay!)

    self.setNeedsDisplay()
  }
  
  func tapGraph(sender: UITapGestureRecognizer) {
    let tappedPoint = solveNearestPoint(selectedPoint: sender.location(in: self), points: graph)

    var selectedDay = graph.index(of: tappedPoint)
    if selectedDay == 0 {
      selectedDay = 1
    }
    //self.selectedDay = selectedDay!
    delegate.pointTaped(selectedDay: selectedDay!)
    
    self.setNeedsDisplay()
  }
  
  public func setSelected(day: Int){
    self.selectedDay = day
  }
  
  override func draw(_ rect: CGRect) {
    let alpha:CGFloat = 1.0
    self.texts.forEach {
      $0.text = ""
    }
    self.texts = []

    //以降グラフを書くので描画範囲の設定
    let rect_ = CGRect(
      x: rect.minX + 30,
      y: rect.minY + 30,
      width: rect.width - 10 * CGFloat(2),
      height: rect.height - 30 * CGFloat(2))
    
    let xInterval:CGFloat = rect_.height / CGFloat(5 + 1) //日にち分と基軸 x軸の間隔
    let yInterval:CGFloat = rect_.width / CGFloat(yLabel.count + 1) //縦軸6本と基軸 y軸の間隔
    
    //グラフのラベルの設定
    var label_text:String = ""
    var sub_label_text:String = ""
    var label_len:Int = 0
    switch type {
    case .Distance:
      label_text = "距離"
      sub_label_text = "km"
      label_len = 2
    case .Time:
      label_text = "時間"
      sub_label_text = "s"
      label_len = 2
    case .Pace:
      label_text = "ペース"
      sub_label_text = "km/h"
      label_len = 3
    }
    
    var strSize = 32
    var att = [
      NSFontAttributeName: UIFont(name: "HiraginoSans-W0", size: CGFloat(strSize))!,
      NSForegroundColorAttributeName: UIColor(red:163/255, green: 170/255, blue:176/255, alpha: 0.5)
    ] as [String : Any]
    NSString(string: label_text).draw(at: CGPoint(x: rect_.minX + CGFloat(10), y: rect_.minY), withAttributes: att)
    // PlaceName
    strSize = 20
    att[NSFontAttributeName] = UIFont(name: "HiraginoSans-W0", size: CGFloat(strSize))!
    NSString(string: sub_label_text).draw(at: CGPoint(x: rect_.minX + CGFloat(10) + CGFloat(label_len * 32) + CGFloat(5), y: rect_.minY + CGFloat(12)), withAttributes: att)
    
    //ToDo ラベルの設定
    for h in 0...6 {
      let label = UILabel(frame: CGRect(x: 0, y: rect_.height - rect_.height * CGFloat(h) / CGFloat(6) + rect_.minY - 5, width: 28, height: 10))
      label.font = UIFont.systemFont(ofSize: CGFloat(8))
      let label_value:String = String(format:"%.1f", CGFloat(h) * yLabel.max()! / CGFloat(6) / 1000)
      label.text = label_value
      label.textAlignment = NSTextAlignment.right
      label.textColor = baseLineColor
      self.addSubview(label)
      texts.append(label)
      //CGContextShowTextAtPoint(c: self, x: 0, y:rect_.height / 6 * (6 - h), string: (h * yLabel.max() / CGFloat(6)), 2)
    }
    
    //基軸を書く
    baseLineColor.setStroke()
    let baseLine = UIBezierPath()
    baseLine.lineWidth = 1.0
    baseLine.move(to: CGPoint(x: rect_.minX, y: rect_.maxY))
    baseLine.addLine(to: CGPoint(x: rect_.minX, y: rect_.minY))
    baseLine.stroke()
    
    baseLine.move(to: CGPoint(x: rect_.minX, y: rect_.maxY))
    baseLine.addLine(to: CGPoint(x: rect_.maxX, y: rect_.maxY))
    baseLine.stroke()
    
    //horizontal line
    for dial in 1...6 {
      let line = UIBezierPath()
      line.lineWidth = 1.0
      let currentPoint:CGPoint = CGPoint(x: rect_.minX, y:rect_.maxY) //左下の座標
      line.move(to:
        CGPoint(
          x: currentPoint.x,
          y: currentPoint.y - CGFloat(dial) * xInterval * alpha
        )
      )
      line.addLine(to:
        CGPoint(
          x: currentPoint.x + xDialSize,
          y: line.currentPoint.y
        )
      )
      line.stroke()
    }
    
    //vertical line
    for dial in 1..<yLabel.count{
      let line = UIBezierPath()
      line.lineWidth = 1.0
      let currentPoint:CGPoint = CGPoint(x: rect_.minX, y:rect_.maxY) //左下の座標
      line.move(to:
        CGPoint(
          x: currentPoint.x + CGFloat(dial) * yInterval * alpha,
          y: currentPoint.y
        )
      )
      line.addLine(to:
        CGPoint(
          x: line.currentPoint.x,
          y: currentPoint.y - yDialSize
        )
      )
      line.stroke()
    }
    
    //描画する座標の追加
    graph = []
//    graph.append(
//      CGPoint(
//        x:rect_.minX + CGFloat(1) * yInterval,
//        y: rect_.maxY - yLabel[0] * rect_.height / CGFloat(yLabel.max()! == 0 ? 1 : yLabel.max()!)
//      )
//    )
    for index in 0..<yLabel.count {
      graph.append(
        CGPoint(
          x: rect_.minX + CGFloat(index) * yInterval,
          y: rect_.maxY - yLabel[index] * rect_.height / CGFloat(yLabel.max()! == 0 ? 1 : yLabel.max()!)
        )
      )
    }
    
    //draw Graph
    lineColor.setStroke()
    let line = UIBezierPath()
    line.lineWidth = 1.0
    line.move(to: graph[0])
    //drawSquare(center: graph[0], size:5)
    for index in 1..<graph.count {
      line.addLine(to: graph[index])
      if index != selectedDay {
        drawSquare(center: graph[index], size:4)
      }
    }
    line.stroke()
    if selectedDay != 0{
        drawSelectedPoint(center: graph[selectedDay], size: 3)
    }
    else {
        drawSelectedPoint(center: graph[1], size: 3)
    }
  }
  
  public func setLabel(xLabel: [String], yLabel: [CGFloat], type: HistoryDataMode) {
    self.xLabel = xLabel
    self.yLabel = yLabel
    self.type = type
    self.setNeedsDisplay()
  }
  
  //月が違う場合の解決も
  public func setDate(date: Date) {
    let day = DayService.getComponent(date: date).day
    if graph.count != 0 {
      selectedDay = day!
    }
  }
  
  private func drawSquare(center: CGPoint, size:CGFloat) {
    lineColor.setStroke()
    lineColor.setFill()
    let square:UIBezierPath =
      UIBezierPath(
        roundedRect: CGRect(x:center.x - size / 2, y:center.y - size / 2, width:size, height:size),
        cornerRadius: 0
      )
    square.fill()
    square.stroke()
  }
  
  private func drawSelectedPoint(center: CGPoint, size: CGFloat) {
    selectedPointColor.setStroke()
    selectedPointColor.setFill()

    let circle1:UIBezierPath =
      UIBezierPath(
        arcCenter: center,
        radius: size,
        startAngle: CGFloat(0),
        endAngle: CGFloat(M_PI * 2),
        clockwise: true
    )
    circle1.fill()
    circle1.stroke()
    
    let circle2:UIBezierPath =
      UIBezierPath(
        arcCenter: center,
        radius: size + 3,
        startAngle: CGFloat(0),
        endAngle: CGFloat(M_PI * 2),
        clockwise: true
    )
    circle2.stroke()
  }

  private func solveNearestPoint(selectedPoint: CGPoint, points: [CGPoint]) -> CGPoint {
    let nears:[CGPoint] = points.sorted(by: {
      (p1: CGPoint, p2: CGPoint) -> Bool in
      return calcDistance2(p1: p1, p2: selectedPoint) < calcDistance2(p1: p2, p2: selectedPoint)
    })
    return nears[0]
  }
  
  private func calcDistance2(p1: CGPoint, p2:CGPoint) -> CGFloat {
    return  (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)
  }
}
