//
//  EditProfileVC.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 12/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Kingfisher
import Alamofire

protocol editprofileDelegate {
    func tappedUpdateInEditProfile(fname:String,lname:String)
}

class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    var delegate:editprofileDelegate?
    
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    
    @IBOutlet weak var headerView: UIView!
    var Fname = ""
    var Lname = ""
    var alltheUserData:DriverMeResonse?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow(view: headerView)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth=1.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        //  profileImageView.layer.cornerRadius = image.frame.size.height/2
        profileImageView.clipsToBounds = true
        txtFname.text = Fname
        txtLname.text = Lname
        
        let img = Defaults[.profileImageString]
        if img != nil{
            let imgRes = ImageResource(downloadURL: URL(string: img)!)
           // profileImageView.kf.setImage(with: imgRes)
            profileImageView.kf.setImage(with: imgRes, placeholder:UIImage(named: "default-user"), options: nil, progressBlock: nil, completionHandler: nil)
        }else{
            print("Could not load Image")
        }
        
        // Do any additional setup after loading the view.
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
      
        
    }

    @IBAction func btnUpdateAcion(_ sender: Any) {
    StartSpinner()
       
        
        let parmm:Parameters = [
            "name":txtFname.text! ,
            "lastname":txtLname.text!,
            "is_agreed":alltheUserData?.data.isAgreed ?? 0,
            "email":alltheUserData?.data.email ?? "no Email",
            
        ]
        
        let token = Defaults[.deviceTokenKey]
        let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
        
        Alamofire.request(WebServiceClass().BaseURL + "driver/update", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSONDecodable { (dataresponse:DataResponse<UpdateProfileInfoResponse>) in
            switch dataresponse.result{
            case .success(let resp):
                StopSpinner()
                if resp.errorCode == 0{
                    print("Update Successfull")
                    print(resp)
                    let alert = AlertBuilder(title: "Greego", message: "Profile updated sucessfully")
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .failure(let err):
                StopSpinner()
                print(err.localizedDescription)
                print("Could not  get Rates from state")
                let alert = AlertBuilder(title: "oops", message: "Could not update profile details")
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedProfileImage(_ sender: Any) {
        showActionSheet()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage

        profileImageView.image = image
        
        
        
        
        dismiss(animated: true, completion: nil)

        
        StartSpinner()
        
        
        let maximumSize : CGFloat = 400*400
        var compressRatio = CGFloat()
        let imageSize1 : CGFloat =  image.size.width * image.size.height
        
        
        if imageSize1 < maximumSize {
            compressRatio = 1
        }
            
        else {
            compressRatio = maximumSize / imageSize1
        }
        
        var img1 =   image.fixOrientation()
        
        var  image1base64 = UIImageJPEGRepresentation(img1, compressRatio)?.base64EncodedString()
        
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
               // print(resp)
                if resp.errorCode == 0{
                    if let profileStatus = resp.data?.profileStatus{

                     
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
        
        
    }
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func photoLibrary()
    {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func showActionSheet() {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
