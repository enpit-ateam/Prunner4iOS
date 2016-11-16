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
//import Alamofire
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
    
    let zoom = 20 - log2(distance/10)
    print(zoom)
    let camera = GMSCameraPosition.camera(withLatitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude, zoom: Float(zoom))
    mapView.camera = camera
    
    /*
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let parameters = [
      "key": appDelegate.apiKey,
      "location": String.init(format: "%f,%f", mapView.camera.target.latitude, mapView.camera.target.longitude),
      "radius": distance
    ] as [String : Any]
    Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json", method: .get, parameters: parameters)
      .responseJSON { response in
        // ここに処理を記述していく
        guard let object = response.result.value else{
          return
        }
        let json = JSON(object)
        json["results"].forEach{(_, place) in
          let location = place["geometry"]["location"].dictionaryValue
          let  position = CLLocationCoordinate2DMake((location["lat"]?.doubleValue)!, (location["lng"]?.doubleValue)!)
          let marker = GMSMarker(position: position)
          marker.title = place["name"].stringValue
          marker.map = self.mapView

        }
      }
 */
    
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
    }
    
    /*
    let parameters = [
      "key": appDelegate.apiKey,
      "origin": String.init(format: "%f,%f", mapView.camera.target.latitude, mapView.camera.target.longitude),
      "destination": String.init(format: "%f,%f", mapView.camera.target.latitude+1.0, mapView.camera.target.longitude+1.0)
      ] as [String : Any]
    Alamofire.request("https://maps.googleapis.com/maps/api/directions/json", method: .get, parameters: parameters)
      .responseJSON { response in
        // ここに処理を記述していく
        guard let object = response.result.value else{
          return
        }
        let json = JSON(object)
        print(object)
    }
 */
    
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
}

