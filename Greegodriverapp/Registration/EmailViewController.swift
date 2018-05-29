//
//  EmailViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/13/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {

    @IBOutlet weak var txtemail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnbackaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextbtnaction(_ sender: Any) {
        
        if(isValidEmail(testStr: txtemail.text!))
        {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupNameVC") as! SignupNameVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            let user = UserDefaults.standard
            
            user.set(txtemail.text!, forKey: "email")
            
            user.synchronize()
        }
        else
        {
            
            
            let alert = UIAlertController(title: nil, message: "Please enter correct Email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
