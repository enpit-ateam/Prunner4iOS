//
//  MapDrawing.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/05.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreFoundation
import GoogleMaps
import CoreLocation

// GoogleMapの描画用メソッドクラス
class MapDrawing {
  
  public init(){}
  
  public func getCamera(withLocation location: Location, distance: Double) -> GMSCameraPosition {
    let zoom = prepareZoom(distance: distance)
    return GMSCameraPosition.camera(withLatitude: location.lat, longitude: location.lng, zoom: Float(zoom))
  }
  
  private func prepareZoom(distance: Double) -> Float {
    let zoom = 20 - log2(distance/10)
    return Float(zoom)
  }
  
  public func getGMSStartMarker(_ current: Location) -> GMSMarker! {
    // set marker
    // TODO:
    //  現在地マーカーのデザイン
    let title = "現在地"
    let marker = createGMSMarker(location: current, title: title)
    return marker
  }

  public func getGMSStartMarker(withLocation location: Location, title: String) -> GMSMarker! {
    // set marker
    // TODO:
    //  現在地マーカーのデザイン
    
    let marker = createGMSMarker(location: location, title: title)
    return marker
  }
  
  public func getGMSEndMarker(_ distination: Place) -> GMSMarker! {
    // set marker
    // TODO:
    //  マーカーのデザイン
    
    if distination.geometry.location == nil {
      print("No Distination")
      return nil
    }
    let location = distination.geometry.location
    let title = distination.name
    let marker = createGMSMarker(location: location!, title: title!)
    return marker
  }
  
  public func getGMSEndMarker(withLocation location: Location, title: String) -> GMSMarker! {
    let marker = createGMSMarker(location: location, title: title)
    return marker
  }
  
  private func createGMSMarker(location: Location, title: String) -> GMSMarker! {
    let pos = CLLocationCoordinate2DMake(location.lat, location.lng)
    let marker = GMSMarker(position: pos)
    marker.title = title
    return marker
  }
  
  public func getGMSPolyline(_ route: Route) -> GMSPolyline! {
    // set polyline
    // TODO:
    //  ルートのデザイン
    let strokeColor = UIColor.blue
    let strokeWidth = 5.0

    let path = GMSMutablePath()
    for leg in route.legs {
      for step in leg.steps {
        path.add(CLLocationCoordinate2DMake(step.startLocation.lat, step.startLocation.lng))
      }
      let last = leg.steps[leg.steps.count-1]
      path.add(CLLocationCoordinate2DMake(last.endLocation.lat, last.endLocation.lng))
    }
    
    let polyline = GMSPolyline(path: path)
    polyline.strokeColor = strokeColor
    polyline.strokeWidth = CGFloat(strokeWidth)
    
    return polyline
  }
}
