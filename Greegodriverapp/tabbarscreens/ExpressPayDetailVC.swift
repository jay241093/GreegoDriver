//
//  ExpressPayDetailVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/23/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class ExpressPayDetailVC: UIViewController {
    @IBOutlet weak var lblamount: UILabel!
    
    @IBOutlet weak var lblgreegofees: UILabel!
    
    
    @IBOutlet weak var lblexpressfee: UILabel!
    var totalfess = ""
    var greegofess = ""
    var expressfees = ""

    @IBOutlet weak var lblexfee: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblamount.text = totalfess
        lblgreegofees.text = greegofess
        lblexpressfee.text = expressfees
        lblexfee.text = expressfees

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction Methods
    @IBAction func back(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)

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
