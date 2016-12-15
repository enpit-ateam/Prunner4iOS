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
  public var waypoints: [Location] = []
  public var selectedWaypoint: Location?
  
  public func initialize() {
    distination = nil
    direction = nil
    camera = nil
    zoom = nil
    candidates = nil
    waypoints = []
    selectedWaypoint = nil
  }
  
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
    let currentDirection : Direction = self.direction!
    let currentRoutes : Route = currentDirection.routes[0]
    var sumDistance = 0
    let currentLegs : [Leg] = currentRoutes.legs
    let LegsLength = currentLegs.count
    for i in 0..<LegsLength {
        sumDistance += currentLegs[i].distance.value
    }
    let doubleSum = Double(sumDistance)
    return doubleSum
    //できたかな？
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
      let d1 = fabs(calcAbsSubLatitude(from: lc1, to: lc) + calcAbsSubLongitude(from: lc1, to: lc) - (actualDistance))
      let d2 = fabs(calcAbsSubLatitude(from: lc2, to: lc) + calcAbsSubLongitude(from: lc2, to: lc) - (actualDistance))
      return d1 < d2
    }
    self.candidates = sortedPlaces
    self.distination = sortedPlaces[0]
  }
  
  private func calcAbsSubLongitude(from A: CLLocationCoordinate2D, to B: CLLocationCoordinate2D) -> Double {
    let R = 6378137.0
    let PI = 3.141513
    
    return (PI*R/180.0) * fabs(A.longitude - B.longitude)
  }
  
  private func calcAbsSubLatitude(from A: CLLocationCoordinate2D, to B: CLLocationCoordinate2D) -> Double {
    let R = 6378137.0
    let PI = 3.141513
    
    let lngR = fabs(R * sin( PI/180.0 * B.longitude))
    return (PI*lngR/180.0) * fabs(A.latitude - B.latitude)
  }
  
  
  private func calcCoordinatesDistance(lc1: CLLocationCoordinate2D, lc2: CLLocationCoordinate2D) -> CLLocationDistance {
    let l1 = CLLocation(latitude: lc1.latitude, longitude: lc1.longitude)
    let l2 = CLLocation(latitude: lc2.latitude, longitude: lc2.longitude)
    return l1.distance(from: l2)
  }
  
  public func sortPlaces(places: [Place], user: UserState) -> [Place] {
    if user.distance == nil && user.current == nil {
      return places
    }
    // 一番Distanceに近いPlaceを返す
    let current: Location = user.current!
    let distance = user.distance!
    let sortedPlaces = places.sorted {(place1 : Place, place2 : Place) -> Bool in
      let lc1 = CLLocationCoordinate2DMake((place1.geometry.location.lat)!, (place1.geometry.location.lng)!)
      let lc2 = CLLocationCoordinate2DMake((place2.geometry.location.lat)!, (place2.geometry.location.lng)!)
      let lc = CLLocationCoordinate2DMake(current.lat, current.lng)
      let d1 = fabs(fabs(lc1.latitude - lc.latitude) + fabs(lc1.longitude - lc.longitude) - distance)
      let d2 = fabs(fabs(lc2.latitude - lc.latitude) + fabs(lc2.longitude - lc.longitude) - distance)
      return d1 < d2
    }
    
    return sortedPlaces
  }
  
  public func getRoute(index : Int = 0) -> Route? {
    return direction?.routes[index]
  }
  
  public func moveWaypoint(from: Location, to: Location) -> Bool {
    let index = waypoints.index(of: from)
    if let i = index {
      self.waypoints[i] = to
      return true
    }
    return false
  }
  
  public func removeWaypoint(location: Location) -> Bool {
    let index = waypoints.index(of: location)
    if let i = index {
      self.waypoints.remove(at: i)
      return true
    }
    return false
  }
  
  private init() {}
  static let sharedInstance = MapState()
}
