//
//  TabbarVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/23/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
   //initDefaults()
        
    if let key = UserDefaults.standard.object(forKey: "isdashbord")
    {
        let value = UserDefaults.standard.value(forKey:"isdashbord") as! Int
        if(value == 1)
        {
            self.selectedIndex = 1;
        }
        
        
        
        }
        // Do any additional setup after loading the view.
    
    }
    override func viewWillLayoutSubviews() {
      
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
