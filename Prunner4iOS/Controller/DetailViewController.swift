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
  var startMarker: GMSMarker!
  var endMarker: GMSMarker!
  var polyline: GMSPolyline!
  
  // 変数
  var history: History!
  
  // IBOutlet
  @IBOutlet weak var resultView: ResultView!
  @IBOutlet weak var mapView: PrunnerMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    placeClient = GMSPlacesClient()
    if let route = history.route,
       let distance = history.distance,
       let start = history.start,
       let end = history.end,
       let placeName = history.placeName
    {
      // マップの描画
      mapView.camera = GMSUtil.getCamera(withLocation: start, distance: distance)
      GMSUtil.setStartMarker(&startMarker, mapView: mapView, current: start)
      GMSUtil.setEndMarker(&endMarker, mapView: mapView, withLocation: end, title: placeName)
      GMSUtil.setPolyline(&polyline, mapView: mapView, route: route)
    }
    
    if let startDate = history.date,
       let distance = history.distance,
       let time = history.time,
       let placeName = history.placeName
    {
      if let result = resultView {
        let distanceKm: Double = distance / 1000.0
        let runTimeHour: Double = Double(time) / 3600.0
        let pace: Double = distanceKm / runTimeHour
        let endDate: Date = startDate.addingTimeInterval(Double(time))
        let startCal: DateComponents = getDateComponents(from: startDate)
        let endCal: DateComponents = getDateComponents(from: endDate)
        let comps: DateComponents = Calendar(identifier: .gregorian).dateComponents([.hour, .minute], from: startCal, to: endCal)
        let mets: Double = 60.0 * distanceKm
        
        // set label
        result.DateLabel.text = getText(from: startCal) + " ~ " + getText(from: endCal)
        result.DistanceLabel.text = String(format: "%.3f", distanceKm)
        result.TimesLabel.text = String(format: "%d:%2d", comps.hour!, comps.minute!)
        result.CalorieLabel.text = String(format: "%.0f", mets)
        result.PaceLabel.text = String(format: "%.1f", pace)
        result.PlaceNameLabel.text = placeName
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func getText(from comp: DateComponents) -> String {
    return String(format: "%2d/%2d %2d:%2d", comp.month!, comp.day!, comp.hour!, comp.minute!)
  }
  
  public func getDateComponents(from date: Date) -> DateComponents {
    let cal = Calendar(identifier: .gregorian)
    let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
    return comps
  }
  
  //@IBAction func removeButtonTapped(_ sender: Any) {
    // TODO: 動きません
  //  removeData()
  //  performSegue(withIdentifier: "backToHistory", sender: nil)
  //}
  
  @IBAction func removeButtonTapped(_ sender: Any) {
    removeData()
    performSegue(withIdentifier: "backToHistory", sender: nil)
  }
  
  private func removeData() {
    HistoryService.removeHistories(history: self.history!)
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
