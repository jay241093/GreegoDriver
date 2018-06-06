//
//  HelpVC.swift
//  greegotaxiapp
//
//  Created by Ravi Dubey on 5/9/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
class HelpVC: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_action(_ sender: Any) {
     self.navigationController?.popViewController(animated: true)

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
