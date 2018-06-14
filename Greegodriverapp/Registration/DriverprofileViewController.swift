//
//  DriverprofileViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/11/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyUserDefaults
class DriverprofileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var btnprofile: UIButton!
    
    @IBOutlet weak var viewprofile: UIView!
    @IBAction func btnbackaction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // initDefaults()
 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        // Do any additional setup after loading the view.
        
        btnprofile.layer.cornerRadius = btnprofile.frame.width/2
        btnprofile.clipsToBounds = true
        
    }

    @objc func imageTapped(gesture:UIGestureRecognizer) {
        if let profile1Pic = gesture.view as? UIImageView {
            print("Image Tapped")
           // showActionSheet()
        }
    }
    
    func camera()
    {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func photoLibrary()
    {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func showActionSheet(img:String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    var imgstr = "";
    var checkimg = "0";
    var imgstr1 = UIImage(named:"");
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
   
        
        
   var image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if(self.checkimg == "0")
        {
            imgstr1 = image
            btnprofile.setBackgroundImage(image, for: .normal)
        }
       
        self.dismiss(animated: true, completion: nil)
      
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnprofileaction(_ sender: Any) {
        
      
        showActionSheet(img: "0")
    }
    
    
    @IBAction func btnnextaction(_ sender: Any) {
        
        
      if (imgstr1 != UIImage(named:""))
      {
        
       StartSpinner()
        
        
            let maximumSize : CGFloat = 400*400
            var compressRatio = CGFloat()
        let imageSize1 : CGFloat = self.imgstr1!.size.width * self.imgstr1!.size.height
           
            
            if imageSize1 < maximumSize {
                compressRatio = 1
            }
                
            else {
                compressRatio = maximumSize / imageSize1
            }
            
        var img1 =   self.imgstr1?.fixOrientation()

        var  image1base64 = UIImageJPEGRepresentation(img1!, compressRatio)?.base64EncodedString()
        
        var url = NSURL(string: WebServiceClass().BaseURL + "driver/update/profile_pic_base64")
        let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        let paramm:Parameters = [
            "image":image1base64!
        ]
        
        Alamofire.request(WebServiceClass().BaseURL + "driver/update/profile_pic_base64", method: .post, parameters: paramm, encoding: JSONEncoding.default, headers: headers).responseJSONDecodable { (rsp:DataResponse<DriverProfileRespModel>) in
            switch rsp.result{
                case .success(let resp):
                StopSpinner()
                //if success then lets save userprofile to defaults
                
                Defaults.synchronize()
                print("updated profileStatus is : \(Defaults[.profileStatusKey])")
                print(resp)
                if resp.errorCode == 0{
                    if let profileStatus = resp.data?.profileStatus{
                        Defaults[.profileStatusKey] = profileStatus
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let alert = AlertBuilder(title: "oops", message: resp.message)
                        self.present(alert, animated: true, completion: nil)

                    }
                
                
                }else{
                let alert = AlertBuilder(title: "oops", message: resp.message)
                self.present(alert, animated: true, completion: nil)
                }
                
                //lets push him to another screen
                
                case .failure(let err):
                    StopSpinner()

                print(err.localizedDescription)
                let alert = AlertBuilder(title: "oops", message: "Could Not Upload Profile Photo \n Try Again ")
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        //Tasks
        //if success
        //      test error code from resp
//                        if zero -> go to next
//                        else show the response message
        //if failure
        //      show generic error
//                print debug descs
        //save profileStatus to userdefaults from resp
        //
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print(response.result.value!)
//
//                    StopSpinner()
//                    var dic = response.result.value as! NSDictionary
//                    var datadic :NSDictionary = dic.value(forKey: "data") as! NSDictionary
//                    let profilestatus = datadic.value(forKey: "profilestatus") as! Int
//                    let status = profilestatus as! NSNumber
//
//                    let user = UserDefaults.standard
//                    user.set(status.stringValue, forKey:"profilestatus")
//                    user.synchronize()
//
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    if let err = response.error{
//                        return
//                    }
//                }
//            case .failure(let error):
//                StopSpinner()
//
//                print("Error in upload: \(error.localizedDescription)")
        //}
        
        
        }
       else
        
      {
        
        
        let  ALert = AlertBuilder(title:"Alert", message:"Please upload your profile picture")
         self.present(ALert, animated: true, completion: nil)
        
        }
        
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 2
    }
    
}
