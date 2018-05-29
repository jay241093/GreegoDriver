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
    
    @IBOutlet weak var view1: UILabel!
    
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var lbl4: UILabel!
    
    @IBOutlet weak var lbl5: UILabel!
    
    @IBOutlet weak var lblReferCode: UILabel!
    
    @IBOutlet weak var imguser: UIImageView!
    @IBOutlet weak var btnOnOff: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            //  viewFirstPopUp.isHidden = true
            //  self.setShadow()
            //   self.showFirstPopUp()
            
            
            
            
        }
        
        self.view.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        
        // setLeftView(textfield: txtmanual)
        
        
        // Do any additional setup after loading the view.
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
                                
                                self.view1.isHidden = false
                                
                            }
                            if((typedic.value(forKey: "is_suv") as? NSNumber) == 1)
                            {
                                self.lbl2.isHidden = false
                                
                                
                            }
                            if((typedic.value(forKey: "is_van") as? NSNumber) == 1)
                            {
                                self.lbl3.isHidden = false
                                
                                
                            }
                            if((typedic.value(forKey: "is_auto") as? NSNumber) == 1)
                            {
                                
                                self.lbl4.isHidden = false
                                
                            }
                            if((typedic.value(forKey: "is_manual") as? NSNumber) == 1)
                            {
                                self.lbl5.isHidden = false
                                
                                
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
