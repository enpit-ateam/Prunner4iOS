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
import Social

class DetailViewController: UIViewController {
  
  // GoogleMap
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?
  
  @IBOutlet weak var twButton: CustomButton!
  var history: History!
  
  @IBOutlet weak var runDistance: UILabel!
  @IBOutlet weak var runTime: UILabel!
  @IBOutlet weak var pace: UILabel!
  @IBOutlet weak var value: UILabel!
  
  @IBOutlet weak var mapView: PrunnerMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    placeClient = GMSPlacesClient()
    if let route = history.route,
       let start = history.runStart(),
       let point = history.runEnd(),
       let distance = history.distance,
       let time = history.time
    {
      
      // 描画
      let drawing = MapDrawing()
      mapView.camera = drawing.getCamera(withLocation: start, distance: distance)
      let GMSStartMarker = drawing.getGMSStartMarker(withLocation: start, title: "スタート")!
      let GMSEndMarker = drawing.getGMSEndMarker(withLocation: point, title: "中継地点")!
      let GMSDirection = drawing.getGMSPolyline(route)!
      
      GMSStartMarker.map = self.mapView
      GMSEndMarker.map = self.mapView
      GMSDirection.map = self.mapView
      
      runTime.text      = time.description
      runDistance.text  = distance.description
      pace.text         = (distance / Double(time)).description
      value.text        = "Good!"
    }
  }
  @IBAction func twTapped(_ sender: Any) {
    let cv = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
    cv?.setInitialText("てすとてきすと")
    self.present(cv!, animated: true, completion:nil )
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
