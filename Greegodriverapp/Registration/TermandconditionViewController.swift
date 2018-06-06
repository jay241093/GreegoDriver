//
//  TermandconditionViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/13/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import  Alamofire
import CTCheckbox
import SVProgressHUD
import SwiftyUserDefaults

class TermandconditionViewController: UIViewController,UIScrollViewDelegate {
    
    
    @IBOutlet weak var cb: CTCheckbox!
    
    @IBOutlet weak var lblagree: UILabel!
    
    @IBOutlet weak var textview: UITextView!
    var ischecked:String = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gettermscondition()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        textview.isEditable = false
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var lastContentOffset: CGFloat = 0
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // moved to top
            
            cb.isHidden = false
            lblagree.isHidden = false
            
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            cb.isHidden = true
            lblagree.isHidden = true
            
            // moved to bottom
        } else {
            // didn't move
        }
    }
    
    
    @IBAction func btnbackaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextbtnaction(_ sender: Any) {
        
        
        
        
        if(ischecked == "0")
            
        {
            let alert = UIAlertController(title: nil, message: "Please accept terms and condition", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else
        {
            
            
            
            getuserprofile()
            
        }
    }
    
    
    
    @IBAction func checkbox(_ sender: Any) {
        
        if(ischecked == "0")
        {
            ischecked = "1"
        }
        else
        {
            ischecked = "0"
            
            
        }
    }
    
    
    
    
    func gettermscondition()
    {
        
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(WebServiceClass().BaseURL+"get/texts", method:.get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        //print(response.result.value!)
                        
                        
                        StopSpinner()
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            let newdic: NSDictionary = dic.value(forKey:"data") as! NSDictionary
                            let text = newdic.value(forKey:"terms_conditions") as! String
                            let htmlData = NSString(string: text).data(using: String.Encoding.unicode.rawValue)
                            
                            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                            
                            let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
                            
                            self.textview.attributedText = attributedString
                            
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
    //MARK: - USER DEFINE FUNCTIONS
    
    func getuserprofile()
    {
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            let parameters = [
                "name":UserDefaults.standard.value(forKey: "fname") as! String,
                "lastname": UserDefaults.standard.value(forKey: "lname") as! String,
                "promocode": "1234",
                "email": UserDefaults.standard.value(forKey: "email") as! String,
                
                "is_agreed": ischecked,
                
                ]
            Alamofire.request(WebServiceClass().BaseURL+"driver/update", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    
                    StopSpinner()
                    
                    if let data = response.result.value{
                        print(response.result.value!)
                        
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            
                            let newdic: NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            
                            
                            let status = newdic.value(forKey: "profile_status") as! NSNumber
                            
                            
                            let user = UserDefaults.standard
                            
                            
                            user.set(status.stringValue, forKey: "profilestatus")
                            
                            user.synchronize()
                            
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverpersonalinfoViewController") as! DriverpersonalinfoViewController
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                            
                              Defaults[.isAleradyLoggedIn] = true
                            
                            
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
    
    
}
