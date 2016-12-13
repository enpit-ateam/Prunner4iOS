//
//  DoneViewController.swift
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

class DoneViewController: UIViewController {
  
  let userState = UserState.sharedInstance
  let mapState = MapState.sharedInstance
  
  @IBOutlet weak var mapView: PrunnerMapView!
  @IBOutlet weak var resultView: ResultView!
  
  // GoogleMap
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?
  var startMarker: GMSMarker!
  var endMarker: GMSMarker!
  var polyline: GMSPolyline!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // run sceneに戻ってほしくないのでNavigation Backを消す
    self.navigationItem.hidesBackButton = true

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

  @IBAction func recordButtonTapped(_ sender: Any) {
    HistoryService.addHistories(history:
      History(date: Date(),
              route: userState.route,
              distance: userState.distance,
              time: userState.runTime))
    performSegue(withIdentifier: "TOP", sender: nil)
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
