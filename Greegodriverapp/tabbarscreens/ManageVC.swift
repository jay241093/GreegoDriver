//
//  ManageVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/18/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import  SwiftyJSON
import SwiftyUserDefaults
import SVProgressHUD
import Alamofire
import Kingfisher

class ManageVC: UIViewController {
 
    @IBOutlet weak var lblsedan: UILabel!
    
    @IBOutlet weak var lblsuv: UILabel!
    
    @IBOutlet weak var lblvan: UILabel!
    
    @IBOutlet weak var lblauto: UILabel!
    
    @IBOutlet weak var lblmanual: UILabel!
    
    @IBOutlet weak var view1: UILabel!
    
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var lbl4: UILabel!
    
    @IBOutlet weak var lbl5: UILabel!
    
    @IBOutlet weak var lblReferCode: UILabel!
    
    @IBOutlet weak var imguser: UIImageView!
    @IBOutlet weak var btnOnOff: UIImageView!

    var isOnOffBtnON : Bool = true
    
    
    
  var issedan = 0
  var issuv = 0
  var isvan = 0
  var isauto = 0
  var ismanual = 0




    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let T1 = UITapGestureRecognizer()

        T1.addTarget(self, action: #selector(actionsedan))
        lblsedan.addGestureRecognizer(T1)
        
        let T2 = UITapGestureRecognizer()
        
        T2.addTarget(self, action: #selector(actionsuv))
        lblsuv.addGestureRecognizer(T2)
        
        let T3 = UITapGestureRecognizer()
        
        T3.addTarget(self, action: #selector(actionvan))
        lblvan.addGestureRecognizer(T3)
        
        let T4 = UITapGestureRecognizer()
        T4.addTarget(self, action: #selector(actionauto))
        lblauto.addGestureRecognizer(T4)
        
        let T5 = UITapGestureRecognizer()
        T5.addTarget(self, action: #selector(actionmanual))
        lblmanual.addGestureRecognizer(T5)
        
        
        
        
        
        let tap1 = UITapGestureRecognizer()
        tap1.addTarget(self, action: #selector(OnOffButtonAction))
        btnOnOff.addGestureRecognizer(tap1)
        isOnOffBtnON = Defaults[.isOnOffBtnON]

        imguser.layer.borderWidth=1.0
        imguser.layer.masksToBounds = false
        imguser.layer.borderColor = UIColor.white.cgColor
        imguser.layer.cornerRadius = imguser.frame.size.height/2
        imguser.clipsToBounds = true
        
        
        view1.layer.cornerRadius = view1.frame.width/2
        lbl2.layer.cornerRadius = lbl2.frame.width/2
        lbl3.layer.cornerRadius = lbl3.frame.width/2
        lbl4.layer.cornerRadius = lbl4.frame.width/2
        lbl5.layer.cornerRadius = lbl5.frame.width/2
        view1.clipsToBounds = true
        lbl2.clipsToBounds = true
        lbl3.clipsToBounds = true
        lbl4.clipsToBounds = true
        lbl5.clipsToBounds = true
        
        
        lblReferCode.layer.borderWidth = 1.0
        lblReferCode.layer.borderColor = UIColor.darkGray.cgColor
        let tap = UITapGestureRecognizer()
        tap.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        imguser.addGestureRecognizer(tap)
        if revealViewController() != nil
        {
        
            
        }
        
        self.view.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        
      
    }

  @objc func actionsedan()
  {
    if(issedan == 0)
    {
        issedan = 1
         checkdrivertype()
        
    }
    else{
        issedan = 0
        checkdrivertype()
    }
    
    
    }
    @objc func actionsuv()
    {
        if(issuv == 0)
        {
            issuv = 1
            checkdrivertype()
            
        }
        else{
            issuv = 0
            checkdrivertype()
        }
        
        
    }
    @objc func actionvan()
    {
        if(isvan == 0)
        {
            isvan = 1
            checkdrivertype()
            
        }
        else{
            isvan = 0
            checkdrivertype()
        }
        
        
    }
    @objc func actionauto()
    {
        if(isauto == 0)
    {
        isauto = 1
        checkdrivertype()
        
    }
    else{
        isauto = 0
        checkdrivertype()
        }
      
        
    }
    @objc func actionmanual()
    {
        if(ismanual == 0)
        {
            ismanual = 1
            checkdrivertype()
            
        }
        else{
            ismanual = 0
            checkdrivertype()
        }
        
        
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
                        //print(response.result.value!)
                        self.checkuser()
                      
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if Defaults[.isOnOffBtnON]{
            btnOnOff.image = #imageLiteral(resourceName: "ON")
            
        }else{
            btnOnOff.image = #imageLiteral(resourceName: "OFF")
        }
        
        let image = Defaults[.profileImageString]
        let resource = ImageResource(downloadURL: URL(string: image)!)
        
        imguser.kf.setImage(with: resource, placeholder: UIImage(named:"download"), options: nil, progressBlock: nil, completionHandler: nil)
        checkuser()
    }
    
    
    
    var requestID  = 0
    override func viewDidDisappear(_ animated: Bool) {
        //received notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let driverme = DriverMe{
            if let promo = driverme.data.promocode{
                lblReferCode.text = "Your Code is \(promo.uppercased())"
            }else{
                lblReferCode.text = "Loading..."
            }
        }
        
        //received notification
        NotificationCenter.default.addObserver(self, selector:  #selector(AcceptRequest), name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)
    }
    
    @objc func AcceptRequest(note:Notification)
    {
        //close the sidebar if already open
        
        if reveal.frontViewPosition == FrontViewPosition.right {
            reveal.revealToggle(animated: true)
            
        }
        
        let jsonObj = JSON(note.userInfo!)
        
        let  requestID = jsonObj["request_id"].intValue
        print("received a request====\(requestID)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let RequestDriverViewController = storyBoard.instantiateViewController(withIdentifier: "RequestDriverVC") as! RequestDriverVC
        
        RequestDriverViewController.requestID = requestID
        self.navigationController?.pushViewController(RequestDriverViewController, animated: true)
        
    }
    
    // MARK: - IBAction Methods
    
    
    @IBAction func shareaction(_ sender: Any) {
        var shareText = ""
        if let driverme = DriverMe{
            
            if let promo = driverme.data.promocode{
                
                shareText = "Come Drive with Greego.Use my promo code \(promo) to get $150"
                let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
                present(vc, animated: true)
                
            }else{
                print("unable to share")
                let alert = AlertBuilder(title: "Oops", message: "Unable to share your promocode \n Try Again")
                present(alert, animated: true, completion: nil)
            }
        }
        
        
        
        
        
        
        
        
    }
    
    // MARK: - user define functions
    
    func useUnderline(textfield:UITextField) {
        
        textfield.layer.masksToBounds = true
        
        var border = CALayer()
        var width = CGFloat(1.0)
        border.borderColor = UIColor(red:0.00, green:1.00, blue:0.84, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width: textfield.frame.size.width, height: textfield.frame.size.height)
        
        border.borderWidth = width
        textfield.backgroundColor = UIColor.clear
        textfield.layer.addSublayer(border)
        
    }
    
    @objc func OnOffButtonAction(sender: UITapGestureRecognizer) {
        print("on Off Button Tapped")
        
        
        
        
        var parmm:Parameters = [:]
        if Defaults[.isOnOffBtnON] {
            var refreshAlert = UIAlertController(title: "Greego", message: "Are you sure you want to change from OFF to ON?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                parmm = [
                    "driver_on":1,
                ]
                let token = Defaults[.deviceTokenKey]
                let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
                
                Alamofire.request(WebServiceClass().BaseURL + "driver/update/device", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response:DataResponse<Any>) in
                    switch response.result{
                    case .success(let resp):
                        //print(resp)
                        if self.isOnOffBtnON {
                            self.btnOnOff.image = #imageLiteral(resourceName: "OFF")
                            self.isOnOffBtnON = false
                            Defaults[.isOnOffBtnON] = false
                            
                            
                        }else {
                            self.btnOnOff.image = #imageLiteral(resourceName: "ON")
                            self.isOnOffBtnON = true
                            Defaults[.isOnOffBtnON] = true
                            
                            
                        }
                    case .failure(let err):
                        print(err)
                        print("Failed to change ")
                        let alert = AlertBuilder(title: "OOps", message: "Unable to Change Driver Status \n Try Again")
                        self.present(alert, animated: true, completion: nil)
                        StopSpinner()
                        
                        
                    }
                    
                    
                    
                    //
                    
                    
                    
                }            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
            
            
        }else{
            
            var refreshAlert = UIAlertController(title: "Greego", message: "Are you sure you want to change from ON to OFF?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                parmm = [
                    "driver_on":0,
                ]
                
                let token = Defaults[.deviceTokenKey]
                let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
                
                Alamofire.request(WebServiceClass().BaseURL + "driver/update/device", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response:DataResponse<Any>) in
                    switch response.result{
                    case .success(let resp):
                        // print(resp)
                        if self.isOnOffBtnON {
                            self.btnOnOff.image = #imageLiteral(resourceName: "OFF")
                            self.isOnOffBtnON = false
                            Defaults[.isOnOffBtnON] = false
                            
                            
                        }else {
                            self.btnOnOff.image = #imageLiteral(resourceName: "ON")
                            self.isOnOffBtnON = true
                            Defaults[.isOnOffBtnON] = true
                            
                            
                        }
                    case .failure(let err):
                        print(err)
                        print("Failed to change ")
                        let alert = AlertBuilder(title: "OOps", message: "Unable to Change Driver Status \n Try Again")
                        self.present(alert, animated: true, completion: nil)
                        StopSpinner()
                        
                        
                    }
                    
                    
                    
                    //
                    
                    
                    
                }            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
            
        }
        
        
        //if current img is on
        // when tapped ,send 1 to server
        // on successfull responce change image to off
        
        
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
                        print(response.result.value!)
                        
                        StopSpinner()
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            
                            let newdic: NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            
                            let typedic: NSDictionary  = newdic.value(forKey:"type") as! NSDictionary
                            
                            
                            Defaults[.profileStatusKey] = newdic.value(forKey:"profile_status") as! Int

                            var isapprove = newdic.value(forKey:"is_approve") as! Int

                            let profilelevel = Defaults[.profileStatusKey]
                            if profilelevel < 7{
                                //incomplete information
                                
                                self.imguser.isUserInteractionEnabled = false
                                
                            }else if profilelevel == 7 && isapprove == 0{
                                // under Review
                                
                                self.imguser.isUserInteractionEnabled = false
                                //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                                
                                
                                
                            }else if profilelevel == 7 && isapprove != 0{
                                //NO Notifications
                                
                                self.imguser.isUserInteractionEnabled = true
                                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                                
                                
                                
                            }
                            
                            
                            if((typedic.value(forKey: "is_sedan") as? NSNumber) == 1)
                            {
                                self.issedan = 1
                                self.view1.isHidden = false
                                
                            }
                            else
                            {
                                self.issedan = 0
                                self.view1.isHidden = true
                            }
                                
                            if((typedic.value(forKey: "is_suv") as? NSNumber) == 1)
                            {
                                 self.issuv = 1
                                self.lbl2.isHidden = false
                                
                                
                            }
                            else
                            {
                                self.issuv = 0
                                self.lbl2.isHidden = true
                            }
                            if((typedic.value(forKey: "is_van") as? NSNumber) == 1)
                            {
                                self.isvan = 1
                                self.lbl3.isHidden = false
                                
                                
                            }
                            else
                            {
                                self.isvan = 0
                                self.lbl3.isHidden = true
                            }
                            if((typedic.value(forKey: "is_auto") as? NSNumber) == 1)
                            {
                                
                                self.isauto = 1

                                self.lbl4.isHidden = false
                                
                            }
                            else
                            {
                                self.isauto = 0
                                self.lbl4.isHidden = true
                            }
                            if((typedic.value(forKey: "is_manual") as? NSNumber) == 1)
                            {
                                self.ismanual = 1
                                self.lbl5.isHidden = false
                                
                                
                            }
                            else
                            {
                                self.ismanual = 0
                                self.lbl5.isHidden = true
                            }
                            
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
    
    func setrightView(textfield:UITextField)
    {
        textfield.contentMode = .scaleToFill
        
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "help"))
        imageView.frame = CGRect(x: 0, y: 0, width: textfield.frame.size.height-10, height: textfield.frame.size.height-10)
        
        textfield.rightViewMode = UITextFieldViewMode.always
        
        textfield.addSubview(imageView)
        textfield.rightView = imageView
        textfield.textRect(forBounds: textfield.bounds)
        textfield.placeholderRect(forBounds: textfield.bounds)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
