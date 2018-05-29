//
//  Payment Settings.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 12/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class PaymentSettings: UIViewController {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var txtFRoutingNumber: UITextField!
    @IBOutlet weak var txtFAccountNumber: UITextField!
    
    var routingNumber = ""
    var AccountNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        txtFRoutingNumber.text = routingNumber
        
        let decodedData = Data(base64Encoded: AccountNumber)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        txtFAccountNumber.text = decodedString

        setShadow(view: header)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backbtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
