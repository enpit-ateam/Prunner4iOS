//
//  ViewController.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/01.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{

  var locationManager: CLLocationManager?
  var mapView: GMSMapView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // 位置情報サービスが利用できるかどうかをチェック
    if CLLocationManager.locationServicesEnabled() {
      locationManager = CLLocationManager()
      locationManager?.delegate = self;
      // 測位開始
      locationManager?.startUpdatingLocation();
    }
    
    // カメラを作成
    let camera = GMSCameraPosition.camera(withLatitude: -33.868,
                                          longitude:151.2086, zoom:6)
    // ビューを作成
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
    mapView?.isMyLocationEnabled = true;
    
    
    /*
    let marker = GMSMarker()
    marker.position = camera.target
    marker.snippet = "Hello World"
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
    */

    self.view = mapView
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
    mapView?.animate(toLocation: newLocation.coordinate)
  }
}

