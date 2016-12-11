//
//  ModalViewController.swift
//  Prunner4iOS
//
//  Created by kentooda on 2016/12/10.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit
import CoreFoundation
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class ModalViewController: UIViewController {
  
  @IBAction func modalButtonTapped(_ sender: Any) {
            performSegue(withIdentifier: "DONE", sender: nil)
  }
  
  @IBAction func closeButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}
