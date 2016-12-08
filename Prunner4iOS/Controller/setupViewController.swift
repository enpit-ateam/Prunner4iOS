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

class SetupViewController: UIViewController, GMSMapViewDelegate {
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    mapView.delegate = self
    
    placeClient = GMSPlacesClient()
    
    mapState.setCamera(user: userState)
    mapView.camera = mapState.camera!
    
    getPlaces(distance: userState.distance!, location: userState.current!) { places in
      if places == nil || places.count == 0 {
        // TODO:
        // エラー処理
        return
      }
      self.mapState.candidates = places
      self.mapState.setDistinateFromCandidates(for: self.userState)
      self.generateDirection()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  public func generateDirection() {
    let location = self.mapState.distination!.geometry.location!
    let current = self.userState.current!
    self.getDirection(current: current, target: location) { direction in
      if direction == nil {
        // TODO:
        // エラー処理
        return
      }
      self.mapState.direction = direction
      let distination = self.mapState.distination!
      let route = self.mapState.getRoute()!
      
      // 描画
      // TODO: refactor
      if self.startMarker != nil {
        self.startMarker.map = nil
      }
      if self.endMarker != nil {
        self.endMarker.map = nil
      }
      if self.polyline != nil {
        self.polyline.map = nil
      }
      for waypointMarker in self.waypointMarkers {
        if waypointMarker == nil {
          continue
        }
        waypointMarker!.map = nil
      }
      
      let drawing = MapDrawing()
      self.startMarker = drawing.getGMSStartMarker(current)!
      self.endMarker = drawing.getGMSEndMarker(distination)!
      var _waypointMarkers: [GMSMarker?] = []
      for waypoint in self.mapState.waypoints {
        let _waypointMarker = drawing.getGMSStartMarker(waypoint)
        _waypointMarkers.append(_waypointMarker)
      }
      self.waypointMarkers = _waypointMarkers
      self.polyline = drawing.getGMSPolyline(route)!
      
      self.startMarker.map = self.mapView
      self.endMarker.map = self.mapView
      self.polyline.map = self.mapView
      for waypointMarker in self.waypointMarkers {
        waypointMarker!.map = self.mapView
      }
    }
  }
  
  private func getPlaces(distance: Double, location: Location, _ callback: @escaping ([Place]!) -> Void) {
    // Placeのリストを返す
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = GMPlaceRequest.NearBySearch()
    
    request.queryParameters = [
      "key": appDelegate.apiKey as AnyObject,
      "location": String.init(format: "%f,%f", location.lat, location.lng) as AnyObject,
      "radius": String.init(format: "%f", distance) as AnyObject
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

  @IBAction func runButtonTapped(_ sender: Any) {
    if !mapState.isReady() {
      return
    }
    userState.route = mapState.getRoute()
    performSegue(withIdentifier: "RUN", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "RUN" {
      let _ = segue.destination as! RunViewController
    }
  }
  
  public func generateWaypointsRequest(target: Location, waypoints: [Location]?) -> String {
    var request: String = ""
    // optimize:trueでwaypointsの最適化を行う
    request += "optimize:false"
    
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
  
  // MARK: GMSMapViewDelegate
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    let location = Location(lat: coordinate.latitude, lng: coordinate.longitude)
    self.mapState.waypoints.append(location)

    generateDirection()
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
