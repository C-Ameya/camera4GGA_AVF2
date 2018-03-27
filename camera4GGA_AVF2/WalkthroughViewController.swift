//
//  WalkthroughViewController.swift
//  camera4GGA_AVF2
//
//  Created by Chie Takahashi on 2018/03/27.
//  Copyright © 2018年 ctak. All rights reserved.
//

import UIKit
import BWWalkthrough

class WalkthroughViewController: BWWalkthroughViewController {
  
  @IBAction func skipButton(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewcontroller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    self.present(viewcontroller, animated: true, completion: nil)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
