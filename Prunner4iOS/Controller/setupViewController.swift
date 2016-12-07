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

class SetupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var userState = UserState.sharedInstance
  var mapState = MapState.sharedInstance
  
  // GoogleMap
  var placePicker: GMSPlacePicker?
  var placeClient: GMSPlacesClient?
  
  var GMSStartMarker: GMSMarker!
  var GMSEndMarker: GMSMarker!
  var GMSDirection: GMSPolyline!

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var mapView: PrunnerMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    // Do any additional setup after loading the view.
    placeClient = GMSPlacesClient()
    
    mapState.setCamera(user: userState)
    mapView.camera = mapState.camera!
    
    getPlaces(distance: userState.distance!, location: userState.current!) { places in
      if places == nil || places.count == 0 {
        // TODO:
        // エラー処理
        return
      }
      self.mapState.candidates = self.mapState.sortPlaces(places: places, user: self.userState)
      self.mapState.setDistinateFromCandidates(for: self.userState)
      
      let location = self.mapState.distination!.geometry.location!
      let current = self.userState.current!
      self.getDirection(current: current, target: location) { direction in
        if direction == nil {
          // TODO:
          // エラー処理
          return
        }
        self.mapState.direction = direction
        let distination = self.mapState.distination!
        let route = self.mapState.getRoute()!
        
        // 描画
        let drawing = MapDrawing()
        self.GMSStartMarker = drawing.getGMSStartMarker(current)!
        self.GMSEndMarker = drawing.getGMSEndMarker(distination)!
        self.GMSDirection = drawing.getGMSPolyline(route)!
        
        self.GMSStartMarker.map = self.mapView
        self.GMSEndMarker.map = self.mapView
        self.GMSDirection.map = self.mapView
        
        self.tableView.reloadData()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
    guard let places = self.mapState.candidates else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for:indexPath) as UITableViewCell
      
      cell.textLabel?.text = "TMP"
      return cell
    }
    self.mapState.candidates = self.mapState.sortPlaces(places: places, user: self.userState)
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for:indexPath) as UITableViewCell
    
    cell.textLabel?.text = self.mapState.candidates?[indexPath.row].name
    return cell
  }
  
  //データの個数を返すメソッド
  func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
    guard let places = self.mapState.candidates else {
      return 0
    }
    self.mapState.candidates = self.mapState.sortPlaces(places: places, user: self.userState)
    guard let count = self.mapState.candidates?.count else {
      return 0
    }
    return count
  }
  
  func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
    guard let places = self.mapState.candidates else {
      return
    }
    
    guard let location = self.mapState.candidates?[indexPath.row].geometry.location! else{
      return
    }
    
    self.mapState.distination = self.mapState.candidates?[indexPath.row]
    
    let current = self.userState.current!
    self.getDirection(current: current, target: location) { direction in
      if direction == nil {
        // TODO:
        // エラー処理
        return
      }
      self.mapState.direction = direction
      let distination = self.mapState.distination!
      let route = self.mapState.getRoute()!
      
      // 描画
      self.GMSStartMarker.map = nil
      self.GMSEndMarker.map = nil
      self.GMSDirection.map = nil
      
      let drawing = MapDrawing()
      self.GMSStartMarker = drawing.getGMSStartMarker(current)!
      self.GMSEndMarker = drawing.getGMSEndMarker(distination)!
      self.GMSDirection = drawing.getGMSPolyline(route)!
      
      self.GMSStartMarker.map = self.mapView
      self.GMSEndMarker.map = self.mapView
      self.GMSDirection.map = self.mapView
      
      self.tableView.reloadData()
    }
  }
  
  private func getPlaces(distance: Double, location: Location, _ callback: @escaping ([Place]!) -> Void) {
    // Placeのリストを返す
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

  @IBAction func runButtonTapped(_ sender: Any) {
    if !mapState.isReady() {
      return
    }
    userState.route = mapState.getRoute()
    performSegue(withIdentifier: "RUN", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "RUN" {
      let _ = segue.destination as! RunViewController
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
