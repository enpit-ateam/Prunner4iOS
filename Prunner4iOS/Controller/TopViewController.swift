//
//  TopViewController.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/11/28.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreLocation

class TopViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var inputDistanceTextField: UITextField!
  var locationManager: CLLocationManager?
  var userState = UserState.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    // 位置情報サービスが利用できるかどうかをチェック
    if CLLocationManager.locationServicesEnabled() {
      locationManager = CLLocationManager()
      locationManager?.delegate = self
      
      // 測位開始
      locationManager?.requestLocation()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func tappedButton(_ sender: UIButton) {
    userState.setDistance(text: inputDistanceTextField.text)
    if !userState.isReady() {
      return
    }
    performSegue(withIdentifier: "SETUP", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SETUP" {
      let _ = segue.destination as! SetupViewController
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      userState.current = Location(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
    } else {
      print("Could't get any location services.")
    }
  }
  
  // 取得に失敗した場合
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failure")
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
