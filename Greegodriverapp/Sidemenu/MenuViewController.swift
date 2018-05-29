//
//  MenuViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/11/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    
    @IBOutlet weak var sidemenu: UIBarButtonItem!
    
    
    @IBOutlet weak var mainmenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil
        {
            mainmenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
           // sidemenu.target = revealViewController()
           // sidemenu.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sidemenuaction(_ sender: Any) {
        
       
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
