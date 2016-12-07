//
//  DoneViewController.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/11/28.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController {
  
  let userState = UserState.sharedInstance
  
  @IBOutlet weak var runTimeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // run sceneに戻ってほしくないのでNavigation Backを消す
    self.navigationItem.hidesBackButton = true

    runTimeLabel.text = userState.putRunTimeResult()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func recordButtonTapped(_ sender: Any) {
    HistoryService.addHistories(history:
      History(date: Date(),
              route: userState.route,
              distance: userState.distance,
              time: userState.runTime))
    performSegue(withIdentifier: "TOP", sender: nil)
  }
  
  @IBAction func returnButtonTapped(_ sender: Any) {
    performSegue(withIdentifier: "TOP", sender: nil)
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
