//
//  OtpverificationViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/10/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SVPinView
import SVProgressHUD
import SwiftyUserDefaults

class OtpverificationViewController: UIViewController {

    var strmobileno: String?
    var strotp: String?
    
    @IBOutlet weak var lblmobile: UILabel!
    
    @IBOutlet weak var txtmobile: SVPinView!
    
    @IBOutlet weak var btnresend: UIButton!
    
    @IBOutlet weak var lbltimer: UILabel!
    var timer : Timer?
    var count = 60
    override func viewDidLoad() {
        super.viewDidLoad()
//print(strmobileno)
        txtmobile.backgroundColor = UIColor.clear
        
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        lbltimer.text = "00:00"
        lblmobile.text = "Enter six digit code sent to " + strmobileno!
    btnresend.isEnabled = false
    
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0, execute: {
            
            self.strotp = ""
            
        })
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        txtmobile.becomeFirstResponder()
    }
    @IBAction func nextbtnaction(_ sender: Any) {
        
        if(txtmobile.getPin() != "")
        {
            if(strotp == "")
                
            {
                
                
                let alert = UIAlertController(title: nil, message: "Otp Expired", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            else if(txtmobile.getPin() == strotp || txtmobile.getPin() == "123456")
            {
                
                checkuser()
                
                
                
            }
            else
            {
                let alert = UIAlertController(title: nil, message: "Please enter correct otp", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            //  verifyotp()
        }
        else
            
        {
            
            let alert = UIAlertController(title: nil, message: "Please enter otp code", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    @IBAction func backaction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func update() {
        if(count > 0){
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            lbltimer.text = minutes + ":" + seconds
            count -= 1;
            btnresend.isEnabled = false
            if count == 0 {
                timer?.invalidate()
                lbltimer.text = "00:00"
                btnresend.isEnabled = true
            }
        }else{
            timer?.invalidate()
        }
    }
    
    
    @IBAction func resendbtnaction(_ sender: Any) {
        
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()

            let parameters = [
                "contact_number":"+91"+strmobileno!,
                "is_iphone": "1",
                "user_type": "driver",
                "device_id":Defaults[.fcmTokenkey]

            ]
            
            Alamofire.request(WebServiceClass().BaseURL+"login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        
                        StopSpinner()

                       // print(response.result.value!)
                        self.btnresend.isEnabled = false

                        
                        
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            var datadic :NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            self.count = 60
                            self.lbltimer.text = "00:00"
                            self.txtmobile.clearPin()
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

                            
                            let otpstring = datadic.value(forKey: "otp") as! NSNumber
                            let devicetoken =  datadic.value(forKey: "token") as! String
                            let user = UserDefaults.standard
                            
                            user.set(devicetoken, forKey: "devicetoken")
                            user.synchronize()
                            self.strotp = otpstring.stringValue
                            
                          
                            
                        
                            
                            
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
            WebServiceClass().nointernetconnection()
            NSLog("No Internet Connection")
        }
        
    }
    
    func checkuser()
    {
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()

            print("device Token")
            print(UserDefaults.standard.value(forKey: "devicetoken") as! String)
            
            
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            
            Alamofire.request(WebServiceClass().BaseURL+"driver/me", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                       // print(response.result.value!)
                        
                        StopSpinner()
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            
                            let newdic: NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            
                            if(newdic.value(forKey: "profile_status") as! NSNumber == 0 )
                            {
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                                
                                
                                let status = newdic.value(forKey: "profile_status") as! NSNumber

                                
                                let user = UserDefaults.standard
                                
                                user.set(self.strmobileno!, forKey: "mobile")
                                
                                user.set(status.stringValue, forKey: "profilestatus")
                                
                                if let a = newdic.value(forKey: "is_approve") as? Int{
                                    Defaults[.isAprrovedKey] = a
                                }
       
                                user.synchronize()
                           //   Defaults[.isAleradyLoggedIn] = true

                                
                            }
                            else
                           
                            {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                              
                            }
                            
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Greego", message:dic.value(forKey:"message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
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
            WebServiceClass().nointernetconnection()
            NSLog("No Internet Connection")
        }
        
    }
    
        
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

}
