//
//  RunViewController.swift
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

class RunViewController: UIViewController {
  
  var userState = UserState.sharedInstance
  var mapState = MapState.sharedInstance
  
  // 時間測定用
  var startTime: Date?
  
  // GoogleMap
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?
  
  @IBOutlet weak var mapView: PrunnerMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    startTime = Date()
    placeClient = GMSPlacesClient()
    mapView.camera = mapState.camera!
    
    // マーカーの描画
    let target = self.mapState.distination!
    let direction = self.mapState.direction!
    let start = self.mapView.camera.target
    let distination = CLLocationCoordinate2DMake(target.geometry.location.lat, target.geometry.location.lng)
    let startMarker = GMSMarker(position: start)
    startMarker.title = "現在地"
    startMarker.map = self.mapView
    let distinationMarker = GMSMarker(position: distination)
    distinationMarker.title = target.name
    distinationMarker.map = self.mapView
    
    // ルートの描画
    let path = GMSMutablePath()
    let route = direction.routes[0]
    for leg in (route.legs) {
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
  
  @IBAction func doneButtonTapped(_ sender: Any) {
    userState.setRunTime(start: startTime, end: Date())
    performSegue(withIdentifier: "DONE", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DONE" {
      let _ = segue.destination as! DoneViewController
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
