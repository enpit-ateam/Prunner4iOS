//
//  TopViewController.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/11/28.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

class TopViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var inputDistanceTextField: UITextField!
  
  var locationManager: CLLocationManager?
  var userState = UserState.sharedInstance
  var mapState = MapState.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.

    // 位置情報サービスが利用できるかどうかをチェック
    if CLLocationManager.locationServicesEnabled() {
      locationManager = CLLocationManager()
      locationManager?.delegate = self
      inputDistanceTextField.delegate = self
      
      // 測位開始
      locationManager?.requestLocation()
    }
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    SVProgressHUD.setMinimumDismissTimeInterval(1)
    SVProgressHUD.show(withStatus: "現在地を取得中です")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // userStateの初期化
    userState.initialize()
    // mapStateの初期化
    mapState.initialize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func startButtonTapped(_ sender: Any) {
    userState.setDistance(text: inputDistanceTextField.text)
    if !userState.isReady() {
      return
    }
    performSegue(withIdentifier: "SETUP", sender: nil)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      // 未認証ならリクエストダイアログ出す
      locationManager?.requestWhenInUseAuthorization()
    case .restricted, .denied:
      break
    case .authorizedWhenInUse:
      break
    default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      userState.current = Location(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
      SVProgressHUD.showSuccess(withStatus: "現在地を取得しました")
    } else {
      print("Could't get any location services.")
      SVProgressHUD.showError(withStatus: "現在地の取得に失敗しました")
    }
  }
  
  // 取得に失敗した場合
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failure")
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    inputDistanceTextField.resignFirstResponder()
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (inputDistanceTextField.isFirstResponder) {
      inputDistanceTextField.resignFirstResponder()
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
  
  @IBAction func backToTop(_ segue: UIStoryboardSegue) {}
  
}
