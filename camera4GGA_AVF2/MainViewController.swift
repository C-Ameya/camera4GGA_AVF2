//
//  MainViewController.swift
//  camera4GGA_AVF2
//
//  Created by Chie Takahashi on 2018/03/27.
//  Copyright © 2018年 ctak. All rights reserved.
//

import UIKit
import BWWalkthrough

class MainViewController: UIViewController,BWWalkthroughViewControllerDelegate  {
  
  @IBAction func startWalkthrough(_ sender: Any) {
    print("startWalkthrough")
    let stb = UIStoryboard(name: "Main", bundle: nil)
    let walkthrough = stb.instantiateViewController(withIdentifier: "walk0") as! BWWalkthroughViewController
    let page_one = stb.instantiateViewController(withIdentifier: "walk1") as UIViewController
    let page_two = stb.instantiateViewController(withIdentifier: "walk2") as UIViewController
    let page_three = stb.instantiateViewController(withIdentifier: "walk3") as UIViewController
    
    //マスターにページを追加
    walkthrough.delegate = self
    walkthrough.add(viewController:page_one)
    walkthrough.add(viewController:page_two)
    walkthrough.add(viewController:page_three)
    
    self.present(walkthrough, animated: true, completion: nil)
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
