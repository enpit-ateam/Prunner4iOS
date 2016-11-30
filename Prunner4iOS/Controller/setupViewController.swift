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

class SetupViewController: UIViewController {
  
  // TopSceneから受ける変数
  var current: Location!
  var distance: Double!
  
  // GoogleMap
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?
  
  // member変数
  var target: Place! = nil
  var direction: Direction! = nil
  
  @IBOutlet weak var mapView: PrunnerMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    placeClient = GMSPlacesClient()
    
    let zoom = 20 - log2(distance/10)
    let camera = GMSCameraPosition.camera(withLatitude: current.lat, longitude: current.lng, zoom: Float(zoom))
    mapView.camera = camera
    
    getPlaces(distance: distance, location: current) { places in
      if places == nil || places.count == 0 {
        // TODO:
        // エラー処理
        return
      }
      self.target = self.pickBestPlace(places: places, distance: self.distance)
      let targetLocation = self.target.geometry.location!
      
      self.getDirection(current: self.current, target: targetLocation) { direction in
        if direction == nil {
          // TODO:
          // エラー処理
          return
        }
        self.direction = direction
        
        // マーカーの描画
        let start = self.mapView.camera.target
        let distination = CLLocationCoordinate2DMake(targetLocation.lat, targetLocation.lng)
        let startMarker = GMSMarker(position: start)
        startMarker.title = "現在地"
        startMarker.map = self.mapView
        let distinationMarker = GMSMarker(position: distination)
        distinationMarker.title = self.target.name
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func getPlaces(distance: Double, location: Location, _ callback: @escaping ([Place]!) -> Void) {
    // 指定されたLat,LngからのPlaceリストを返す
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
      "destination": String.init(format: "%f,%f", target.lat, target.lng) as AnyObject,
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
  
  
  @IBAction func runButtonTapped(_ sender: Any) {
    if direction == nil {
      return
    }
    performSegue(withIdentifier: "RUN", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "RUN" {
      let vc = segue.destination as! RunViewController
      vc.current = current
      vc.distance = distance
      vc.target = target
      vc.direction = direction
    }
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
