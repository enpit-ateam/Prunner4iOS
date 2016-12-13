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
  
  let userState = UserState.sharedInstance
  let mapState = MapState.sharedInstance
  
  // 時間測定用
  var startTime: Date?
  
  // GoogleMap
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?
  var startMarker: GMSMarker!
  var endMarker: GMSMarker!
  var polyline: GMSPolyline!
 
  @IBOutlet weak var mapView: PrunnerMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    startTime = Date()
    placeClient = GMSPlacesClient()
    
    // マップの描画
    mapView.camera = mapState.camera!
    GMSUtil.setStartMarker(&startMarker, mapView: mapView, current: userState.current!)
    GMSUtil.setEndMarker(&endMarker, mapView: mapView, withDistination: mapState.distination!)
    GMSUtil.setPolyline(&polyline, mapView: mapView, route: userState.route!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func checkButtonTapped(_ sender: Any) {
    userState.setRunTime(start: startTime, end: Date())
    //performSegue(withIdentifier: "DONE", sender: nil)
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
