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

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn1.titleLabel?.textAlignment = .center
        btn2.titleLabel?.textAlignment = .center
        btn3.titleLabel?.textAlignment = .center
        btn4.titleLabel?.textAlignment = .center

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
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
