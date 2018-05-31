//
//  MobilenumberViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/10/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyUserDefaults
import  SwiftCop

class MobilenumberViewController: UIViewController {
    
    
    @IBOutlet weak var txtmobilenumber: customTextField!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
//        txtmobilenumber.leftViewMode = UITextFieldViewMode.always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
//        let image = UIImage(named: "flag for mobile")
//        imageView.image = image
//        txtmobilenumber.leftView = imageView
//        txtmobilenumber.textInputView.frame.origin.x += 70
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.txtmobilenumber.becomeFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextbtnaction(_ sender: Any) {
        
        if(txtmobilenumber.text == "")
        {
            let alert = UIAlertController(title: nil, message: "Please enter correct mobile number.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else
        {
            
            checkmobile()
            
            
            
        }
        
    }
    
    //MARK: - USER DEFINE FUNCTIONS
    func checkmobile()
    {
        if AppDelegate.hasConnectivity() == true
        {
            
            
            StartSpinner()
            // print(txtmobilenumber.text!)
            let parameters = [
                "contact_number":"+1"+txtmobilenumber.text!,
                "is_iphone": "1",
                "user_type": "driver",
                "device_id":Defaults[.fcmTokenkey]
            ]
            
            Alamofire.request(WebServiceClass().BaseURL+"login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print("MobileNumberViewCOntroller,response of network call:")
                        print(response.result.value!)
                        
                        StopSpinner()
                        
                        
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                           
                            
                            
                            var datadic :NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            let otpstring = datadic.value(forKey: "otp") as! NSNumber
                            let devicetoken =  datadic.value(forKey: "token") as! String
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OtpverificationViewController") as! OtpverificationViewController
                            print(self.txtmobilenumber.text!)
                            nextViewController.strmobileno = self.txtmobilenumber.text!
                            nextViewController.strotp = otpstring.stringValue
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                            
                            let user = UserDefaults.standard
                            
                            user.set(devicetoken, forKey: "devicetoken")
                            user.synchronize()
                            
                            
                        }
                        else{
                            if let message = dic.value(forKey: "message") as? String{
                                let alert = AlertBuilder(title: "oops", message: "mobile number is invalid")
                                self.present(alert, animated: true, completion: nil)

                            }
                            else{
                                let alert = AlertBuilder(title: "oops", message: "Could Not send otp on this number")
                                self.present(alert, animated: true, completion: nil)

                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    StopSpinner()
                    print(response.result.error)
                    let alert = AlertBuilder(title: "Could not connect", message: "Please check your internet connection")
                    self.present(alert, animated: true, completion: nil)
                    break
                    
                }
            }
            
        }
        else
        {
            WebServiceClass().nointernetconnection()
            NSLog("No Internet Connection")
        }
        
    }
    
    
    
}
