//
//  SettingViewController.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/11/28.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreFoundation
import GoogleMaps
import GooglePlacePicker
import CoreLocation
import SwiftyJSON

import APIKit

class SetupViewController: UIViewController, GMSMapViewDelegate, TabSelectViewDelegate {

  var userState = UserState.sharedInstance
  var mapState = MapState.sharedInstance
  
  // GoogleMap
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?

  var startMarker: GMSMarker!
  var endMarker: GMSMarker!
  var waypointMarkers: [GMSMarker?] = []
  var polyline: GMSPolyline!

  @IBOutlet weak var mapView: PrunnerMapView!
  @IBOutlet weak var tabSelectView: TabSelectView!
  let tabMax: Int = 3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    tabSelectView.delegate = self
    tabSelectView.tabStore!.append(RouteSelectElement(title: "", placeName: "", distance: ""))
    
    placeClient = GMSPlacesClient()
    mapView.delegate = self
    mapState.setCamera(user: userState)
    mapView.camera = mapState.camera!
    
    setupMapView()
  }
  
  public func setupMapView() {
    getPlaces(distance: userState.distance!, location: userState.current!) { places in
      if places == nil || places.count == 0 {
        // TODO:
        // エラー処理
        return
      }
      self.mapState.candidates = self.mapState.sortPlaces(places: places, user: self.userState)
      self.mapState.setDistinateFromCandidates(for: self.userState)
      
      self.setView(for: self.tabSelectView, tab: self.tabMax, with: self.mapState.candidates!)
      
      self.drawMapView()
    }
  }
  
  public func drawMapView() {
    let current = self.userState.current!
    let target = self.mapState.distination?.geometry.location
    self.getDirection(current: current, target: target!) { direction in
      if direction == nil {
        // TODO:
        // エラー処理
        return
      }
      self.mapState.direction = direction
      let route = self.mapState.getRoute()!
      
      // マップの更新
      GMSUtil.setStartMarker(&self.startMarker, mapView: self.mapView, current: self.userState.current!)
      GMSUtil.setEndMarker(&self.endMarker, mapView: self.mapView, withDistination: self.mapState.distination!)
      GMSUtil.setPolyline(&self.polyline, mapView: self.mapView, route: route)
      GMSUtil.replaceWaypointMarkers(&self.waypointMarkers, mapView: self.mapView, waypoints: self.mapState.waypoints)
      
      // タブの更新
      let routeDistanceKM = self.mapState.calcDirectionDistance() / 1000.0
      self.updateView(for: self.tabSelectView, distance: routeDistanceKM)
    }
    
  }
  
  private func setView(for view: TabSelectView, tab: Int, with places: [Place]) {
    view.tabStore = []
    for (index, place) in places.enumerated() {
      if index >= tab {
        break
      }
      view.tabStore!.append(RouteSelectElement(title: "", placeName: place.name, distance: ""))
    }
    view.selector = 0
    view.setNeedsDisplay()
  }
  
  private func updateView(for view: TabSelectView, distance: Double) {
    view.tabStore![view.selector].distance = String(format: "%.2f", distance)
    view.setNeedsDisplay()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: GMSMapViewDelegate
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    let location = Location(lat: coordinate.latitude, lng: coordinate.longitude)
    self.mapState.waypoints.append(location)
    
    drawMapView()
  }
  
  // MARK: Back to TOP
  @IBAction func backButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
    // Markerのドラッグ開始時に呼ばれる
    // Marker.isDraggable = falseのマーカーは呼ばれない
    // WayPointとして設定したマーカーのみ呼ばれる
    let tappedPosition: Location = Location(lat: marker.position.latitude, lng: marker.position.longitude)
    self.mapState.selectedWaypoint = detectTappedWaypoint(location: tappedPosition)
  }
  
  func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
    // Markerのドラッグ終了時に呼ばれる
    if self.mapState.selectedWaypoint == nil {
      return
    }
    let tappedPosition: Location = Location(lat: marker.position.latitude, lng: marker.position.longitude)
    let selected: Location = self.mapState.selectedWaypoint!
    if self.mapState.moveWaypoint(from: selected, to: tappedPosition) {
      drawMapView()
    }
    self.mapState.selectedWaypoint = nil
  }
  
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    if marker.title != "削除" {
      return
    }
    let tappedPosition: Location = Location(lat: marker.position.latitude, lng: marker.position.longitude)
    if let waypoint = detectTappedWaypoint(location: tappedPosition) {
      if self.mapState.removeWaypoint(location: waypoint) {
        drawMapView()
      }
    }
  }
  
  // MARK: tab selector delegate
  func onSelectorChanged(index: Int) {
    tabSelectView.selector = index
    mapState.distination = self.mapState.candidates?[index]
    mapState.waypoints = []
    drawMapView()
  }

  @IBAction func checkButtonTapped(_ sender: Any) {
    if !mapState.isReady() {
      return
    }
    userState.route = mapState.getRoute()
    performSegue(withIdentifier: "RUN", sender: nil)
  }
  
  public func generateWaypointsRequest(target: Location, waypoints: [Location]?) -> String {
    var request: String = ""
    // optimize:trueでwaypointsの最適化を行う
    request += "optimize:true"
    
    // add target to waypoint request
    request = request + "|" + String.init(format: "%f,%f", target.lat, target.lng)
    
    if waypoints == nil {
      return request
    }
    // add waypoints to waypoint request
    for waypoint in waypoints! {
      request = request + "|" + String.init(format: "%f,%f", waypoint.lat, waypoint.lng)
    }
    
    return request
  }
  
  private func getPlaces(distance: Double, location: Location, _ callback: @escaping ([Place]!) -> Void) {
    // Placeのリストを返す
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = GMPlaceRequest.NearBySearch()
    let actualDistance = distance / 2.0
    request.queryParameters = [
      "key": appDelegate.apiKey as AnyObject,
      "location": String.init(format: "%f,%f", location.lat, location.lng) as AnyObject,
      "radius": String.init(format: "%f", actualDistance) as AnyObject
    ]
    var places: [Place]!
    Session.send(request) { result in
      switch result {
      case .success(let response):
        print(response)
        places = response
      case .failure(let error):
        print("error: \(error)")
      }
      callback(places)
    }
  }
  
  private func getDirection(current: Location, target: Location, _ callback: @escaping (Direction!) -> Void) {
    // ルートの取得
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = GMDirectionRequest()
    
    request.queryParameters = [
      "origin": String.init(format: "%f,%f", current.lat, current.lng) as AnyObject,
      "destination": String.init(format: "%f,%f", current.lat, current.lng) as AnyObject,
      "waypoints": generateWaypointsRequest(target: target, waypoints: self.mapState.waypoints) as AnyObject,
      "travelMode": "walking" as AnyObject,
      "key": appDelegate.apiKey as AnyObject
    ]
    var direction: Direction!
    Session.send(request) { result in
      switch result {
      case .success(let response):
        print(response)
        direction = response
      case .failure(let error):
        print("error: \(error)")
      }
      callback(direction)
    }
  }
  
  private func detectTappedWaypoint(location: Location) -> Location? {
    var nearest: Location?
    var minDistance: Double?
    for waypoint in self.mapState.waypoints {
      if minDistance == nil {
        minDistance = calcDistanceLocation(from: location, to: waypoint)
        nearest = waypoint
      } else if let min = minDistance {
        let dist = calcDistanceLocation(from: location, to: waypoint)
        if min > dist {
          minDistance = dist
          nearest = waypoint
        }
      }
    }
    return nearest
  }
  
  private func calcDistanceLocation(from: Location, to: Location) -> Double {
    let latDistance: Double = (from.lat - to.lat)
    let lngDistance: Double = (from.lng - to.lng)
    return latDistance * latDistance + lngDistance * lngDistance
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  @IBAction func backToSetup(_ segue: UIStoryboardSegue) {}

  
}
