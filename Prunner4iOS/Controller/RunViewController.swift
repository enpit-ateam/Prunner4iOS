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
  
  var route: Route?
  
  @IBOutlet weak var mapView: PrunnerMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    startTime = Date()
    placeClient = GMSPlacesClient()
    mapView.camera = mapState.camera!
    
    // 描画
    let current = userState.current!
    let GMSStartMarker = mapState.getGMSStartMarker(current)!
    let GMSEndMarker = mapState.getGMSEndMarker()!
    let GMSDirection = mapState.getGMSPolyline()!
    userState.setSelectedRoute(selectedRoute: mapState.getRoute())

    GMSStartMarker.map = self.mapView
    GMSEndMarker.map = self.mapView
    GMSDirection.map = self.mapView
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
