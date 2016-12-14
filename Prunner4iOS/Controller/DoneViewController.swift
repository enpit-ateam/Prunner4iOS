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
import Social

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
    
    // ResultViewの描画
    drawResultViewLabel()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  private func drawResultViewLabel() {
    if let result = resultView {
      let distance: Double = mapState.calcDirectionDistance() / 1000.0
      let time: Double = Double(userState.calcRunTime()!) / 3600.0
      let pace: Double = distance / time
      let startCal = getDateComponents(from: userState.startDate!)
      let endCal = getDateComponents(from: userState.endDate!)
      let comps = Calendar(identifier: .gregorian).dateComponents([.hour, .minute], from: startCal, to: endCal)
      let mets: Double = 60.0 * distance
      result.DateLabel.text = getText(from: startCal) + " ~ " + getText(from: endCal)
      result.DistanceLabel.text = String(format: "%.3f", distance)
      result.TimesLabel.text = String(format: "%d:%2d", comps.hour!, comps.minute!)
      result.CalorieLabel.text = String(format: "%.0f", mets)
      result.PaceLabel.text = String(format: "%.1f", pace)
      result.PlaceNameLabel.text = mapState.distination?.name
    }
  }
  
  private func getText(from comp: DateComponents) -> String {
    return String(format: "%2d/%2d %2d:%2d", comp.month!, comp.day!, comp.hour!, comp.minute!)
  }
  
  public func getDateComponents(from date: Date) -> DateComponents {
    let cal = Calendar(identifier: .gregorian)
    let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
    return comps
  }

  
  @IBAction func historyButtonTapped(_ sender: Any) {
    HistoryService.addHistories(history:
      History(date: Date(),
              route: userState.route,
              distance: userState.distance,
              time: userState.calcRunTime(),
              placeName: mapState.distination?.name))
    performSegue(withIdentifier: "backToTop", sender: nil)
  }
  
  @IBAction func tweetButtonTapped(_ sender: Any) {
    let cv = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
    cv.setInitialText("")
    self.present(cv, animated: true, completion: nil)
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
