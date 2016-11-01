//
//  ViewController.swift
//  Prunner4iOS
//
//  Created by 黒澤 預生 on 2016/11/01.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let camera = GMSCameraPosition.camera(withLatitude: -33.868,
                                                      longitude:151.2086, zoom:6)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
    
    let marker = GMSMarker()
    marker.position = camera.target
    marker.snippet = "Hello World"
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
    
    self.view = mapView
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

