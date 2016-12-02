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
  
  private init() {}
  static let sharedInstance = MapState()
}
