//
//  DoneModalViewController.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/12/13.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class CancelModalViewController: UIViewController, SlideSwitchViewDelegate {
  
  @IBOutlet weak var sliderView: SlideSwitchView!
  var initialFlg = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    sliderView.controllerRadius = CGFloat(60)
    sliderView.margin = CGFloat(5)
    sliderView.baseColorHex = "ee7a33"
    sliderView.controllerPoint = sliderView.controllerInitPosition
    sliderView.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func dismissPopup(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func onSwitched() {
    if initialFlg {
      performSegue(withIdentifier: "backToSetup", sender: nil)
      dismiss(animated: true, completion: nil)
      initialFlg = false
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
