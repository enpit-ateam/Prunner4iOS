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
    let distance = NSString(string: distanceText!)
    
    let zoom = 20 - log2(distance.doubleValue/10)
    print(zoom)
    let camera = GMSCameraPosition.camera(withLatitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude, zoom: Float(zoom))
    mapView.camera = camera
    
    
    //Placeを取得してmapに表示させる
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request = GMPlaceRequest.NearBySearch()
    request.queryParameters = [
      "key": appDelegate.apiKey as AnyObject,
      "location": String.init(format: "%f,%f", mapView.camera.target.latitude, mapView.camera.target.longitude) as AnyObject,
      "radius": distance as AnyObject
    ]
    Session.send(request) { result in
      switch result {
      case .success(let response):
        let places = response
        places.forEach{(place) in
          let  position = CLLocationCoordinate2DMake((place.geometry.location.lat)!, (place.geometry.location.lng)!)
          let marker = GMSMarker(position: position)
          marker.title = place.name
          marker.map = self.mapView
          
          //lat, lngからdistanceを求める
          //もっとも求めている距離になりそうなplace順にソートする このタスクについて
        }
        places.sorted {(place1 : Place, place2 : Place) -> Bool in
          let  lc1 = CLLocationCoordinate2DMake((place1.geometry.location.lat)!, (place1.geometry.location.lng)!)
          let d1 = fabs(self.calcCoordinatesDistance(lc1: lc1, lc2: camera.target) - distance.doubleValue)
          let  lc2 = CLLocationCoordinate2DMake((place2.geometry.location.lat)!, (place2.geometry.location.lng)!)
          let d2 = fabs(self.calcCoordinatesDistance(lc1: lc2, lc2: camera.target) - distance.doubleValue)
          return d1 > d2
        }
        self.drawRoute(places[0])
      case .failure(let error):
        print("error: \(error)")
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
    
    /*
    //ある距離からある距離までのルートを取得
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var request = GMDirectionRequest()
    request.queryParameters = [
      "origin": String.init(format: "%f,%f", mapView.camera.target.latitude, mapView.camera.target.longitude) as AnyObject,
      "destination": String.init(format: "%f,%f", mapView.camera.target.latitude+1.0, mapView.camera.target.longitude+1.0) as AnyObject,
      "key": appDelegate.apiKey as AnyObject
    ]
    Session.send(request) { result in
      switch result {
      case .success(let response):
        let direction = response
        print(direction)
      case .failure(let error):
        print("error: \(error)")
      }
    }*/
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
  
  private func calcCoordinatesDistance(lc1: CLLocationCoordinate2D, lc2: CLLocationCoordinate2D) -> CLLocationDistance {
    let l1 = CLLocation(latitude: lc1.latitude, longitude: lc1.longitude)
    let l2 = CLLocation(latitude: lc2.latitude, longitude: lc2.longitude)
    return l1.distance(from: l2)
  }

  private func drawRoute(place: Place){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var request = GMDirectionRequest()
    request.queryParameters = [
    "origin": String.init(format: "%f,%f", mapView.camera.target.latitude, mapView.camera.target.longitude) as AnyObject,
    "destination": String.init(format: "%f,%f", place.geometry.location.lat, place.geometry.location.lng) as AnyObject,
    "key": appDelegate.apiKey as AnyObject
    ]
    Session.send(request) { result in
      switch result {
      case .success(let response):
        let direction = response
      case .failure(let error):
        print("error: \(error)")
      }
    }
  }
}

