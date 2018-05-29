//
//  SettingViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/12/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import Rswift
import Kingfisher
import Alamofire


class SettingViewController: UIViewController,navigationSettingsDelegate {
    
    
    @IBOutlet weak var settingview: UIView!
    
    @IBOutlet weak var nameview: UIView!
    
    @IBOutlet weak var emailview: UIView!
    
    
    @IBOutlet weak var mobileview: UIView!
    
    @IBOutlet weak var paymentview: UIView!
    
    @IBOutlet weak var navigatiobview: UIView!
    
    @IBOutlet weak var logoutview: UIView!
    @IBOutlet weak var lblNavigationApp: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblNameOfUser: UILabel!
    @IBOutlet weak var lblJoinedOn: UILabel!
    
    
    @IBOutlet weak var lblEmailID: UILabel!
    @IBOutlet weak var lblEmailVerified: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setShadow(view: settingview)
        setShadow(view: nameview)
        setShadow(view: emailview)
        setShadow(view: mobileview)
        setShadow(view: paymentview)
        setShadow(view: navigatiobview)
        setShadow(view: logoutview)
        // Do any additional setup after loading the view.
    }

    func selectedNavigatonApp() {
        checkAndSetNavigationAppName()
    }
    
    func checkAndSetNavigationAppName(){
        if Defaults[.SelectedNavigationAppKey] == 0{
            lblNavigationApp.text = "Google Maps"
        }
        else if  Defaults[.SelectedNavigationAppKey] == 1 {
            lblNavigationApp.text = "Waze"
        }
        else
        {
            lblNavigationApp.text = "Apple Maps"

        }
    }
    
    
    
    var requestID  = 0
    override func viewDidDisappear(_ animated: Bool) {
        //received notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Approved"), object: nil)

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkAndSetNavigationAppName()
        
        
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds =  true
        
        
        if let driverMe = DriverMe {
            //
            func formatDateAndReturn(datestr:String) -> String{
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                
                dateFormatterPrint.dateFormat = "MMM dd, yyyy"
                
                if let date = dateFormatterGet.date(from: datestr){
                    let requireddate = dateFormatterPrint.string(from: date)
                    print(requireddate)
                    return "Joined \(requireddate)"
                }
                else {
                    print("There was an error decoding the string")
                    return "Could not find date"
                }            }//
            
            lblNameOfUser.text = "\(driverMe.data.name!) \(driverMe.data.lastname!)"
            if let aa = driverMe.data.bankInformation!.createdAt{
                lblJoinedOn.text = formatDateAndReturn(datestr: aa)

            }
            lblEmailID.text = "\(driverMe.data.email!)"
            lblPhoneNumber.text = "\(driverMe.data.contactNumber!)"
            lblEmailVerified.text = driverMe.data.email_verifed! == 1 ? "Verified" : "Not Verified"
            
            
            if let profStr = driverMe.data.profilePic{
                if profStr != ""{
                    let imgUrlResource = ImageResource(downloadURL: URL(string: profStr)!)
                    profileImage.kf.setImage(with: imgUrlResource, placeholder: UIImage(named: "default-user"), options: nil, progressBlock: nil)

                }
                
            

            }
        }else{
            print("Could Not parse Driver")
            let alert = AlertBuilder(title: "oops", message: "Unable to retrive data")
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
   
    @IBAction func tappedLogOutView(_ sender: UITapGestureRecognizer) {
        
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout ?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            
          var  parmm = [
                "driver_on":0,
            ]
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            Alamofire.request(WebServiceClass().BaseURL + "driver/update/device", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response:DataResponse<Any>) in
                switch response.result{
                case .success(let resp):
                    print(resp)
                    Defaults[.isOnOffBtnON] = true
                   
                case .failure(let err):
                    print(err)
                    print("Failed to change ")
                    let alert = AlertBuilder(title:  "OOps", message: "Unable to Change Driver Status \n Try Again")
                    self.present(alert, animated: true, completion: nil)
                    StopSpinner()
                    
                    
                }
                
                
                
                //
                
                
                
            }
            let a = Defaults[.fcmTokenkey]
            let b = Defaults[.isOnOffBtnON]

            Defaults.removeAll()
            Defaults[.fcmTokenkey] = a
            Defaults[.isOnOffBtnON] = b
            Defaults[.SelectedNavigationAppKey] =  2

            UserDefaults.standard.removeObject(forKey:"isdashbord")

//            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
//            UserDefaults.standard.synchronize()
            
            let FirstVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(FirstVC, animated: true)
//            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            
//            appDel.window?.rootViewController = FirstVC
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        let revealVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(revealVC, animated: true)
     }
    
    
    @IBAction func tappedName(_ sender: UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let EditProfileVControl =  storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC

            EditProfileVControl.alltheUserData = DriverMe
        EditProfileVControl.Fname = DriverMe!.data.name!
        EditProfileVControl.Lname = DriverMe!.data.lastname!

        self.navigationController?.pushViewController(EditProfileVControl, animated: true)

        }

    @IBAction func tappedEmail(_ sender: Any) {
        let updateEmailVc = R.storyboard.main.updateEmailVC()
       updateEmailVc!.email = lblEmailID.text!
        self.navigationController?.pushViewController(updateEmailVc!, animated: true)
    }

    @IBAction func tappedMobileNumber(_ sender: Any) {
//        let story = R.storyboard.main()
//        let mobileNumberVC = R.storyboard.main.mobilenumberViewController()
//       mobileNumberVC. self.navigationController?.pushViewController(WhoAreYou!, animated: true)
    }

    @IBAction func tappedNavigation(_ sender: UITapGestureRecognizer) {
        let story = R.storyboard.main()
        let navigationVC = R.storyboard.main.navigationSettings()
       navigationVC?.delegate = self
        self.navigationController?.pushViewController(navigationVC!, animated: true)

    }
    @IBAction func tappedPayment(_ sender: Any) {
        let story = R.storyboard.main()
        let paymentVC = R.storyboard.main.paymentSettings()
       paymentVC?.AccountNumber = DriverMe!.data.bankInformation!.accountNumber ?? ""
       paymentVC!.routingNumber = DriverMe!.data.bankInformation!.routingNumber ?? ""
    self.navigationController?.pushViewController(paymentVC!, animated: true)
    }
    
    

}
func setShadow(view: UIView)
{
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    view.layer.shadowRadius = 2
}
