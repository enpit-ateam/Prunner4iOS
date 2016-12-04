//
//  DoneViewController.swift
//  Prunner4iOS
//
//  Created by Naoki Kobayashi on 2016/11/28.
//  Copyright © 2016年 黒澤 預生. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController {
  
  var runTime: Int?
  var route: Route?
  
  @IBOutlet weak var runTimeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    print(runTime!)
    runTimeLabel.text = String(runTime!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func doneButtonTapped(_ sender: Any) {
    var rt: Int = 0
    if runTime != nil {
      rt = runTime!
    }
    
    HistoryService.addHistories(history:
      History(date: Date(),
              route: route,
              distance: 114.5141919,
              time: rt)
    )
    performSegue(withIdentifier: "TOP", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TOP" {
      _ = segue.destination as! TopViewController
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
