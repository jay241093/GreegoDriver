//
//  DrivertypeViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/11/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class DrivertypeViewController: UIViewController {

    @IBOutlet weak var btnsedan: UIButton!
    
    @IBOutlet weak var btnsuv: UIButton!
    
    @IBOutlet weak var btnvan: UIButton!
    
    @IBOutlet weak var btnauto: UIButton!

    @IBOutlet weak var btnmanual: UIButton!
    
    @IBOutlet weak var imgsedan: UIImageView!

    @IBOutlet weak var imgsuv: UIImageView!
    
    @IBOutlet weak var imgvan: UIImageView!
    
    @IBOutlet weak var imgauto: UIImageView!
    
    @IBOutlet weak var imgmanual: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var isautomatic : String?
    var issedan = "0"
    var issuv = "0"
    var isvan = "0"
    var isauto = "0"
    var ismanual = "0"
 
    @IBAction func btnsedanaction(_ sender: Any) {
       
        if(issedan == "0"){
            issedan = "1"
             btnsedan.setTitleColor(UIColor(red:0.03, green:0.31, blue:0.38, alpha:1.0), for: .normal)
            imgsedan.isHidden = false
        }else{
           issedan = "0"
        btnsedan.setTitleColor(UIColor.darkGray, for: .normal)
            imgsedan.isHidden = true
        }
       
        
        
    }
    

    @IBAction func btnsuvaction(_ sender: Any) {
        if(issuv == "0"){
            issuv = "1"
            btnsuv.setTitleColor(UIColor(red:0.03, green:0.31, blue:0.38, alpha:1.0), for: .normal)
            imgsuv.isHidden = false
        }else{
            issuv = "0"
            btnsuv.setTitleColor(UIColor.darkGray, for: .normal)
            imgsuv.isHidden = true
        }
    }
    
    @IBAction func btnvanaction(_ sender: Any) {
        
        if(isvan == "0"){
            isvan = "1"
            btnvan.setTitleColor(UIColor(red:0.03, green:0.31, blue:0.38, alpha:1.0), for: .normal)
            imgvan.isHidden = false
        }else{
            isvan = "0"
            btnvan.setTitleColor(UIColor.darkGray, for: .normal)
            imgvan.isHidden = true
        }
 
    }
    
    @IBAction func btnautoaction(_ sender: Any) {
        
        if(isauto == "0"){
            isauto = "1"
            btnauto.setTitleColor(UIColor(red:0.03, green:0.31, blue:0.38, alpha:1.0), for: .normal)
            imgauto.isHidden = false
        }else{
            isauto = "0"
            btnauto.setTitleColor(UIColor.darkGray, for: .normal)
            imgauto.isHidden = true
        }
    }
    
    
    @IBAction func btnmanualaction(_ sender: Any) {
        if(ismanual == "0"){
            ismanual = "1"
            btnmanual.setTitleColor(UIColor(red:0.03, green:0.31, blue:0.38, alpha:1.0), for: .normal)
            imgmanual.isHidden = false
        }else{
            ismanual = "0"
            btnmanual.setTitleColor(UIColor.darkGray, for: .normal)
            imgmanual.isHidden = true
        }
    }
    
    
    
    @IBAction func btnnextaction(_ sender: Any) {
        
        checkdrivertype()
    }
    func checkdrivertype()
    {
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            let parameters = [
                "is_sedan":issedan,
                "is_suv": issuv,
                "is_van": isvan,
                "is_auto": isauto,
                "is_manual": ismanual
            ]
            
            Alamofire.request(WebServiceClass().BaseURL+"driver/update/drivertype", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    
                    StopSpinner()
                    if let data = response.result.value{
                        print(response.result.value!)
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverprofileViewController") as! DriverprofileViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        var dic = response.result.value as! NSDictionary
                        var datadic :NSDictionary = dic.value(forKey: "data") as! NSDictionary
                        let profilestatus = datadic.value(forKey: "profile_status") as! Int
                        let status = profilestatus as! NSNumber
                        print(status.stringValue)
                        let user = UserDefaults.standard
                        user.set(status.stringValue, forKey: "profilestatus")
                        user.synchronize()
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
    
    
}
