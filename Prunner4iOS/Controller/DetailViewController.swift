//
//  DetailViewController.swift
//  Prunner4iOS
//
//  Created by USER on 2016/12/04.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import Foundation

import UIKit
import CoreFoundation
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class DetailViewController: UIViewController {
  
  // member変数
  var route: Route?
  var current: Location?
  var distance: Double!
  var time: Int!
  
  // GoogleMap
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?
  
  var history: History!

  
  @IBOutlet weak var runDistance: UILabel!
  @IBOutlet weak var runTime: UILabel!
  @IBOutlet weak var pace: UILabel!
  @IBOutlet weak var value: UILabel!
  
  @IBOutlet weak var mapView: PrunnerMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    route = history.route
    current = route?.legs[0].startLocation
    distance = history.distance
    time = history.time
    
    runTime.text      = time.description
    runDistance.text  = distance.description
    pace.text         = (distance / Double(time)).description
    value.text        = "Good!"
    
    
    // Do any additional setup after loading the view.
    placeClient = GMSPlacesClient()
    
    let zoom = 20 - log2(distance/10)
    let camera = GMSCameraPosition.camera(withLatitude: current?.lat ?? 0, longitude: current?.lng ?? 0, zoom: Float(zoom))
    mapView.camera = camera
    
    // マーカーの描画
    let start = self.mapView.camera.target
    let distination = CLLocationCoordinate2DMake(route?.legs.last!.endLocation.lat ?? 0, route?.legs.last!.endLocation.lng ?? 0)
    let startMarker = GMSMarker(position: start)
    startMarker.title = "現在地"
    startMarker.map = self.mapView
    let distinationMarker = GMSMarker(position: distination)
    distinationMarker.title = "中継地点"
    distinationMarker.map = self.mapView
    
    // ルートの描画
    let path = GMSMutablePath()
    for leg in (self.route?.legs)! {
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
