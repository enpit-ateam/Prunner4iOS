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
  var delegate: UIGraphViewDelegate!

  var backLineColor:UIColor = UIColor(red:0.972,  green:0.973,  blue:0.972, alpha:1)
  
  var xDialMergin:CGFloat = 30 //目盛り間の距離
  var yDialMergin:CGFloat = 30 //同じ
  let xDialSize:CGFloat = 5 //メモリのサイズ
  let yDialSize:CGFloat = 5 //同じ
  
  var graph:[CGPoint] = []
  var tappedPoint:CGPoint? = nil
  var texts:[UILabel] = []
  
  var baseLineColor:UIColor = UIColor(red:163/255, green: 170/255, blue:176/255, alpha: 1)
  var lineColor:UIColor = UIColor(red:44/255, green:230/255, blue:205/255, alpha: 1)
  var selectedPointColor:UIColor = UIColor(red:251/255, green:148/255, blue:104/255, alpha: 1)
  
  override required init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor(red:228/255,  green:247/255,  blue:254/255, alpha:1)
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(Graph.panGraph(sender:)))
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Graph.tapGraph(sender:)))
    self.addGestureRecognizer(panGesture)
    self.addGestureRecognizer(tapGesture)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func panGraph(sender: UIPanGestureRecognizer) {
    self.tappedPoint = sender.location(in: self)
    if delegate.pointTaped != nil {
      delegate.pointTaped(selectedDay: graph.index(of: solveNearestPoint(selectedPoint: tappedPoint!, points: graph))!)
    }
    self.setNeedsDisplay()
  }
  
  func tapGraph(sender: UITapGestureRecognizer) {
    self.tappedPoint = sender.location(in: self)
    if delegate.pointTaped != nil {
      delegate.pointTaped(selectedDay: graph.index(of: solveNearestPoint(selectedPoint: tappedPoint!, points: graph))!)
    }
    self.setNeedsDisplay()
  }
  
  public func setSelected(day: Int){
    self.tappedPoint = graph[day]
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
      width: rect.width - 30 * CGFloat(2),
      height: rect.height - 30 * CGFloat(2))
    
    let xInterval:CGFloat = rect_.height / CGFloat(5 + 1) //日にち分と基軸 x軸の間隔
    let yInterval:CGFloat = rect_.width / CGFloat(yLabel.count + 1) //縦軸6本と基軸 y軸の間隔
    
    //ToDo ラベルの設定
    for h in 0..<6 {
      let label = UILabel(frame: CGRect(x: 0, y: rect_.height / CGFloat(6) * CGFloat(6 - h), width: 28, height: 10))
      label.font = UIFont.systemFont(ofSize: CGFloat(8))
      let label_value:String = String(format:"%.0f", CGFloat(h) * yLabel.max()! / CGFloat(6))
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
    for dial in 1...yLabel.count{
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
    graph.append(
      CGPoint(
        x:rect_.minX + CGFloat(1) * yInterval,
        y: rect_.maxY - yLabel[0] * rect_.height / CGFloat(yLabel.max()! == 0 ? 1 : yLabel.max()!)
      )
    )
    for index in 1..<yLabel.count {
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
      if graph[index] != tappedPoint {
        drawSquare(center: graph[index], size:4)
      }
    }
    line.stroke()
    if tappedPoint != nil{
      let nearPoint = solveNearestPoint(selectedPoint: tappedPoint!, points:graph)
      drawSelectedPoint(center: nearPoint, size: 3)
    }
  }
  
  public func setLabel(xLabel: [String],yLabel: [CGFloat]) {
    self.xLabel = xLabel
    self.yLabel = yLabel
    self.setNeedsDisplay()
  }
  
  //月が違う場合の解決も
  public func setDate(date: Date) {
    let day = DayService.getComponent(date: date).day
    self.tappedPoint = graph[day!]
    self.setNeedsDisplay()
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
