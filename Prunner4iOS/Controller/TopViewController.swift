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
  var currentLocation: Location?
  
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
    // TODO:
    // 位置情報が取れていないときの動作
    // 例：アラートを出す
    if currentLocation == nil {
      
      return
    }
    // TODO:
    // text fieldの値が正しくないときの動作
    if inputDistanceTextField.text == nil {
      return
    } else if Int(inputDistanceTextField.text!) == nil {
      return
    }
    
    let distance: Double = NSString(string: inputDistanceTextField.text!).doubleValue
    performSegue(withIdentifier: "SETUP", sender: distance)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SETUP" {
      let vc = segue.destination as! SettingViewController
      vc.currentLocation = currentLocation
      vc.distance = sender as? Double
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      currentLocation = Location(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
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
