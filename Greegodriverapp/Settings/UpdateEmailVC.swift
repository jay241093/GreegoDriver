//
//  UpdateEmailVC.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 12/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
class UpdateEmailVC: UIViewController {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var txtFEmail: UITextField!
    @IBOutlet weak var btnSendConfirmationlink: UIButton!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.txtFEmail.text = email
        setShadow(view: header)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SendConfirmaion(_ sender: UIButton) {
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
         
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            let parameters = [
                "device_id": Defaults[.deviceTokenKey]
                
            ]
            
            
            Alamofire.request(WebServiceClass().BaseURL+"driver/verify/email", method: .post, parameters:[:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):

                 StopSpinner()
                    if let data = response.result.value{
                        //print(response.result.value!)
                        
                        
                        
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            
                            let dialogMessage = UIAlertController(title: "Greego", message:"Email sent successfully", preferredStyle: .alert)
                            
                            
                            // Create Cancel button with action handlder
                            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                            }
                            
                            //Add OK and Cancel button to dialog message
                            dialogMessage.addAction(cancel)
                            
                            // Present dialog message to user
                            self.present(dialogMessage, animated: true, completion: nil)
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    StopSpinner()
                    print(response.result.error)
                    break
                    
                }
            }
            
        }
        else
        {
            StopSpinner()
            WebServiceClass().nointernetconnection()
            
            NSLog("No Internet Connection")
        }
    }
    
    @IBAction func backBtnAcion(_ sender: UIButton) {
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
