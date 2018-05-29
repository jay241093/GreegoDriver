//
//  EarningbalanceViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/12/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class EarningbalanceViewController: UIViewController {

    
    @IBOutlet weak var driverview: UIView!
    
    @IBOutlet weak var balanceview: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverview.layer.borderWidth = 1
        
        driverview.layer.borderColor = UIColor.gray.cgColor
        
        balanceview.layer.borderWidth = 1
        balanceview.layer.cornerRadius = 5
        balanceview.layer.borderColor = UIColor.gray.cgColor
        
        
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
