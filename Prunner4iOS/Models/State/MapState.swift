//
//  MapState.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/02.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreFoundation
import GoogleMaps
import CoreLocation

class MapState {
  public var distination: Place?
  public var direction: Direction?
  public var camera: GMSCameraPosition?
  public var zoom: Float?
  public var candidates: [Place]?
  
  public func setCamera(user: UserState) {
    let current: Location = user.current!
    let distance: Double = user.distance!
    let zoom = prepareZoom(distance: distance)
    camera = GMSCameraPosition.camera(withLatitude: current.lat, longitude: current.lng, zoom: Float(zoom))
  }
  
  private func prepareZoom(distance: Double) -> Float {
    let zoom = 20 - log2(distance/10)
    return Float(zoom)
  }
  
  public func isReady() -> Bool {
    if direction == nil {
      return false
    }
    return true
  }
  
  public func calcDirectionDistance() -> Double {
    // TODO:
    // self.directionから距離を計算して返す関数の作成
    return 0.0
  }
  
  public func setDistinateFromCandidates(for user: UserState) {
    if self.candidates == nil {
      return
    }
    if user.distance == nil && user.current == nil {
      return
    }
    // 一番Distanceに近いPlaceを返す
    let current: Location = user.current!
    let distance = user.distance!
    let sortedPlaces = candidates!.sorted {(place1 : Place, place2 : Place) -> Bool in
      let lc1 = CLLocationCoordinate2DMake((place1.geometry.location.lat)!, (place1.geometry.location.lng)!)
      let lc2 = CLLocationCoordinate2DMake((place2.geometry.location.lat)!, (place2.geometry.location.lng)!)
      let lc = CLLocationCoordinate2DMake(current.lat, current.lng)
      let d1 = fabs(self.calcCoordinatesDistance(lc1: lc1, lc2: lc) - distance)
      let d2 = fabs(self.calcCoordinatesDistance(lc1: lc2, lc2: lc) - distance)
      return d1 < d2
    }
    self.distination = sortedPlaces[0]
  }
  
  private func calcCoordinatesDistance(lc1: CLLocationCoordinate2D, lc2: CLLocationCoordinate2D) -> CLLocationDistance {
    let l1 = CLLocation(latitude: lc1.latitude, longitude: lc1.longitude)
    let l2 = CLLocation(latitude: lc2.latitude, longitude: lc2.longitude)
    return l1.distance(from: l2)
  }
  
  public func getGMSStartMarker(_ current: Location) -> GMSMarker! {
    // set marker
    let title = "現在地"
    
    let pos = CLLocationCoordinate2DMake(current.lat, current.lng)
    let marker = GMSMarker(position: pos)
    marker.title = title
    return marker
  }
  
  public func getGMSEndMarker() -> GMSMarker! {
    // set marker
    // TODO:
    
    if self.distination?.geometry.location == nil {
      print("No Distination")
      return nil
    }
    let distination = self.distination!
    let location = distination.geometry.location!
    let title = distination.name
    let pos = CLLocationCoordinate2DMake(location.lat, location.lng)
    let marker = GMSMarker(position: pos)
    marker.title = title
    return marker
  }
  
  public func getGMSPolyline() -> GMSPolyline! {
    // set polyline
    let strokeColor = UIColor.blue
    let strokeWidth = 5.0
    
    if self.direction == nil {
      print("Empty Direction!")
      return nil
    }
    let direction = self.direction!
    
    let path = GMSMutablePath()
    let route = direction.routes[0]
    for leg in (route.legs) {
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
  
  private init() {}
  static let sharedInstance = MapState()
}
