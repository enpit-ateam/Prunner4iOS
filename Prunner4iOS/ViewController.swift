//
//  ViewController.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/01.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreFoundation
import GoogleMaps
import GooglePlacePicker
import CoreLocation
import SwiftyJSON

import APIKit

class ViewController: UIViewController, CLLocationManagerDelegate{

  var locationManager: CLLocationManager?
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?
  
  @IBOutlet var mapView: PrunnerMapView!
  @IBOutlet var distanceTextField: UITextField!
  
  @IBAction func onTappedSearchButton(_ sender: UIButton) {
    distanceTextField.resignFirstResponder()
    mapView.clear()
    
    let distanceText = distanceTextField.text
    let distance = NSString(string: distanceText!).doubleValue
    let currentLat = mapView.camera.target.latitude
    let currentLng = mapView.camera.target.longitude
    let zoom = 20 - log2(distance/10)
    let camera = GMSCameraPosition.camera(withLatitude: currentLat, longitude: currentLng, zoom: Float(zoom))
    mapView.camera = camera
    
    
    getPlaces(distance: distance, latitude: currentLat, longitude: currentLng) { places in
      let bestPlace = self.pickBestPlace(places: places!, distance: distance)
      if places == nil {
        return
      }
      
      self.getDirection(place: bestPlace) { direction in
        if direction == nil {
          return
        }
        
        // マーカーの描画
        let start = self.mapView.camera.target
        let distination = CLLocationCoordinate2DMake(bestPlace.geometry.location.lat, bestPlace.geometry.location.lng)
        let startMarker = GMSMarker(position: start)
        startMarker.title = "現在地"
        startMarker.map = self.mapView
        let distinationMarker = GMSMarker(position: distination)
        distinationMarker.title = bestPlace.name
        distinationMarker.map = self.mapView
        
        // ルートの描画
        let path = GMSMutablePath()
        let route = direction?.routes[0]
        for leg in (route?.legs)! {
          for step in leg.steps {
            path.add(CLLocationCoordinate2DMake(step.startLocation.lat, step.startLocation.lng))
          }
          let last = leg.steps[leg.steps.count-1]
          path.add(CLLocationCoordinate2DMake(last.endLocation.lat, last.endLocation.lng))
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.blue
        polyline.strokeWidth = 5.0
        polyline.map = self.mapView
        
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    placeClient = GMSPlacesClient()
    // 位置情報サービスが利用できるかどうかをチェック
    if CLLocationManager.locationServicesEnabled() {
      locationManager = CLLocationManager()
      locationManager?.delegate = self
      // 測位開始
      locationManager?.startUpdatingLocation()
    }
    
    mapView.isMyLocationEnabled = true
    
    self.view.addSubview(mapView!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    case .restricted, .denied:
      break
    case .authorizedAlways, .authorizedWhenInUse:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let newLocation = locations.last, CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
      return
    }
    let camera = GMSCameraPosition.camera(withLatitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, zoom: mapView.camera.zoom)
    mapView.camera = camera
  }
  
  private func getPlaces(distance: Double, latitude: Double, longitude: Double, _ callback: @escaping ([Place]?) -> Void) {
    // 指定されたLat,LngからのPlaceリストを返す
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = GMPlaceRequest.NearBySearch()
    var places: [Place]?
    request.queryParameters = [
      "key": appDelegate.apiKey as AnyObject,
      "location": String.init(format: "%f,%f", latitude, longitude) as AnyObject,
      "radius": String.init(format: "%f", distance) as AnyObject
    ]
    
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
  
  private func pickBestPlace(places: [Place], distance: Double) -> Place {
    // 一番Distanceに近いPlaceを返す
    let sortedPlaces = places.sorted {(place1 : Place, place2 : Place) -> Bool in
      let lc1 = CLLocationCoordinate2DMake((place1.geometry.location.lat)!, (place1.geometry.location.lng)!)
      let d1 = fabs(self.calcCoordinatesDistance(lc1: lc1, lc2: self.mapView.camera.target) - distance)
      let lc2 = CLLocationCoordinate2DMake((place2.geometry.location.lat)!, (place2.geometry.location.lng)!)
      let d2 = fabs(self.calcCoordinatesDistance(lc1: lc2, lc2: self.mapView.camera.target) - distance)
      return d1 < d2
    }
    return sortedPlaces[0]
  }

  private func calcCoordinatesDistance(lc1: CLLocationCoordinate2D, lc2: CLLocationCoordinate2D) -> CLLocationDistance {
    let l1 = CLLocation(latitude: lc1.latitude, longitude: lc1.longitude)
    let l2 = CLLocation(latitude: lc2.latitude, longitude: lc2.longitude)
    return l1.distance(from: l2)
  }
  
  private func getDirection(place: Place, _ callback: @escaping (Direction?) -> Void) {
    // ルートの取得
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = GMDirectionRequest()
    request.queryParameters = [
      "origin": String.init(format: "%f,%f", mapView.camera.target.latitude, mapView.camera.target.longitude) as AnyObject,
      "destination": String.init(format: "%f,%f", place.geometry.location.lat, place.geometry.location.lng) as AnyObject,
      "key": appDelegate.apiKey as AnyObject
    ]
    var direction: Direction?
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
}

