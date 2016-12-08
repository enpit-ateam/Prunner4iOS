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

// GMS Utility Class
class GMSUtil {

  public static func getCamera(withLocation location: Location, distance: Double) -> GMSCameraPosition {
    let zoom = prepareZoom(distance: distance)
    return GMSCameraPosition.camera(withLatitude: location.lat, longitude: location.lng, zoom: Float(zoom))
  }
  
  private static func prepareZoom(distance: Double) -> Float {
    let zoom = 20 - log2(distance/10)
    return Float(zoom)
  }
  
  public static func setStartMarker(_ marker: inout GMSMarker!, mapView: GMSMapView!, current: Location) {
    reset(marker: marker)
    marker = createGMSMarker(mapView: mapView, location: current, title: "現在地")
    designStartMarker(marker: marker)
  }

  public static func setStartMarker(_ marker: inout GMSMarker!, mapView: GMSMapView!, withLocation location: Location, title: String) {
    reset(marker: marker)
    marker = createGMSMarker(mapView: mapView, location: location, title: title)
    designStartMarker(marker: marker)
  }
  
  public static func setEndMarker(_ marker: inout GMSMarker!, mapView: GMSMapView!, withDistination distination: Place) {
    //  マーカーのデザイン
    
    if distination.geometry.location == nil {
      print("No Distination")
      return
    }
    reset(marker: marker)
    let location = distination.geometry.location!
    let title = distination.name!
    marker = createGMSMarker(mapView: mapView, location: location, title: title)
    designEndMarker(marker: marker)
  }
  
  public static func setEndMarker(_ marker: inout GMSMarker!, mapView: GMSMapView!, withLocation location: Location, title: String) {
    reset(marker: marker)
    marker = createGMSMarker(mapView: mapView, location: location, title: title)
    designEndMarker(marker: marker)
  }
  
  public static func replaceWaypointMarkers(_ markers: inout [GMSMarker?], mapView: GMSMapView!, waypoints: [Location]) {
    // TODO:
    // waypointすべてを取り替えるので効率が悪い
    // 変わりがないwaypointのmarkerは変更しないようにしたい
    
    // reset markers
    for marker in markers {
      if marker == nil {
        continue
      }
      marker!.map = nil
    }
    // set markers with waypoints
    var _markers: [GMSMarker?] = []
    for waypoint in waypoints {
      let _marker = createGMSMarker(mapView: mapView, location: waypoint)
      designWaypointMarker(marker: _marker)
      _markers.append(_marker)
    }
    markers = _markers
  }
  
  public static func setPolyline(_ polyline: inout GMSPolyline!, mapView: GMSMapView!, route: Route) {
    let path = GMSMutablePath()
    for leg in route.legs {
      for step in leg.steps {
        path.add(CLLocationCoordinate2DMake(step.startLocation.lat, step.startLocation.lng))
      }
      let last = leg.steps[leg.steps.count-1]
      path.add(CLLocationCoordinate2DMake(last.endLocation.lat, last.endLocation.lng))
    }
    
    reset(polyline: polyline)
    polyline = createGMSPolyline(mapView: mapView, path: path)
    designPolyline(polyline: polyline)
  }
  
  private static func createGMSMarker(mapView: GMSMapView!, location: Location) -> GMSMarker! {
    let pos = CLLocationCoordinate2DMake(location.lat, location.lng)
    let marker = GMSMarker(position: pos)
    marker.map = mapView
    return marker
  }
  
  private static func createGMSMarker(mapView: GMSMapView!, location: Location, title: String) -> GMSMarker! {
    let pos = CLLocationCoordinate2DMake(location.lat, location.lng)
    let marker = GMSMarker(position: pos)
    marker.title = title
    marker.map = mapView
    return marker
  }
  
  private static func createGMSPolyline(mapView: GMSMapView!, path: GMSMutablePath) -> GMSPolyline! {
    let polyline = GMSPolyline(path: path)
    polyline.map = mapView
    return polyline
  }
  
  private static func reset(marker: GMSMarker!) {
    if marker != nil {
      marker.map = nil
    }
  }
  
  private static func reset(polyline: GMSPolyline!) {
    if polyline != nil {
      polyline.map = nil
    }
  }
  
  private static func designStartMarker(marker: GMSMarker!) {
    if marker == nil {
      return
    }
  }
  
  private static func designEndMarker(marker: GMSMarker!) {
    if marker == nil {
      return
    }
  }
  
  private static func designWaypointMarker(marker: GMSMarker!) {
    if marker == nil {
      return
    }
    marker.icon = GMSMarker.markerImage(with: UIColor.black)
  }
  
  private static func designPolyline(polyline: GMSPolyline!) {
    if polyline == nil {
      return
    }
    let strokeColor = UIColor.blue
    let strokeWidth = 5.0
    
    polyline.strokeColor = strokeColor
    polyline.strokeWidth = CGFloat(strokeWidth)
  }
}
