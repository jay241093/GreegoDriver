//
//  DriverdocumentViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/11/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyUserDefaults

class DriverdocumentViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var insurancrheight: NSLayoutConstraint!
    
    
    @IBOutlet weak var uberheight: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnverification: UIButton!
    
    //@IBOutlet weak var btninsurance: UIButton!
    
    @IBOutlet weak var btninsurance: UIButton!
    
    @IBOutlet weak var lblinsurance: UILabel!
    
    @IBOutlet weak var lbldriver: UILabel!
    
    @IBOutlet weak var insurancemainview: UIView!
    
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var lblfirst: UILabel!
    
    @IBOutlet weak var secondview: UILabel!
    
    @IBOutlet weak var lblsecondview: UIView!
    
    @IBOutlet weak var imginsurance: UIImageView!
    
    @IBOutlet weak var imgdriver: UIImageView!
    @IBOutlet weak var viewdocument: UIView!
    
    @IBOutlet weak var fileattechview: UIView!
    
    @IBOutlet weak var insuranceview: UIView!
    
    @IBOutlet weak var driverview: UIView!
    @IBOutlet weak var fieattechview2: UIView!
    
    @IBOutlet weak var btnuberdriver: UIButton!
    
    @IBOutlet weak var btndriver: UIButton!
    var imgstr = "";
    var checkimg = "0";
    var imgstr1 = UIImage(named:"");
    var imgstr2 = UIImage(named:"");
    var imgstr3 = UIImage(named:"");
    var imgstr4 = UIImage(named:"");
    
    var isImage3Set = false
    var isImage4Set = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        insurancrheight.constant = 0
        uberheight.constant = 0
        self.setShadow(view: viewdocument)
        
        fileattechview.layer.borderWidth = 1
        fileattechview.layer.cornerRadius = 15
        fileattechview.layer.borderColor = UIColor.black.cgColor
        
        fieattechview2.layer.borderWidth = 1
        fieattechview2.layer.cornerRadius = 15
        fieattechview2.layer.borderColor = UIColor.black.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(insuranceview1))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(driverview1))
        lblinsurance.addGestureRecognizer(tapGesture)
        lblinsurance.isUserInteractionEnabled = true
        
        lbldriver.addGestureRecognizer(tapGesture1)
        lbldriver.isUserInteractionEnabled = true
        lblfirst.isHidden = true
        firstview.isHidden = true
        secondview.isHidden = true
        lblsecondview.isHidden = true
    }
    
    @objc func imageTapped(gesture:UIGestureRecognizer) {
        if let profile1Pic = gesture.view as? UIImageView {
            print("Image Tapped")
            //     showActionSheet()
        }
    }
    
    @IBAction func btnbackaction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func photoLibrary()
    {
        
        var myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    func camera()
    {
        var myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    func showActionSheet(img:String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
            self.checkimg = img
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
            self.checkimg = img
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        if(self.checkimg == "0")
        {
            imgstr1 = image
            btnverification.setBackgroundImage(image, for: .normal)
        }
        if(self.checkimg == "1"){
            imgstr2 = image
            btninsurance.setBackgroundImage(image, for: .normal)
        }
        if(self.checkimg == "2"){
            imgstr3 = image
            btnuberdriver.setBackgroundImage(image, for: .normal)
            isImage3Set = true
            
        }
        if(self.checkimg == "3"){
            imgstr4 = image
            btndriver.setBackgroundImage(image, for: .normal)
            isImage4Set = true
        }
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    var click = "0"
    @objc func insuranceview1()
    {
        if(click == "0"){
            
            click = "1"
            insurancrheight.constant = 128
            lblinsurance.textColor = UIColor(red:0.00, green:0.48, blue:0.00, alpha:1.0)
            lblfirst.isHidden = false
            firstview.isHidden = false
            insuranceview.layer.borderWidth = 1
            insuranceview.layer.cornerRadius = 15
            insuranceview.layer.borderColor = UIColor.black.cgColor
            imginsurance.isHidden = false
        }else{
            click = "0"
            insurancrheight.constant = 0
            lblinsurance.textColor = UIColor.black
            lblfirst.isHidden = true
            firstview.isHidden = true
            imginsurance.isHidden = true
        }
        
    }
    
    var click1 = "0"
    @objc func driverview1()
    {
        if(click1 == "0"){
            
            click1 = "1"
            uberheight.constant = 128;
            lbldriver.textColor = UIColor(red:0.00, green:0.48, blue:0.00, alpha:1.0)
            secondview.isHidden = false
            lblsecondview.isHidden = false
            driverview.layer.borderWidth = 1
            driverview.layer.cornerRadius = 15
            driverview.layer.borderColor = UIColor.black.cgColor
            imgdriver.isHidden = false
        }else{
            click1 = "0"
            uberheight.constant = 0;
            lbldriver.textColor = UIColor.black
            secondview.isHidden = true
            lblsecondview.isHidden = true
            imgdriver.isHidden = true
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
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func attechverification(_ sender: Any) {
        showActionSheet(img: "0")
        
    }
    
    @IBAction func insuranceattech(_ sender: Any) {
        showActionSheet(img: "1")
    }
    
    @IBAction func homeinsuranceattech(_ sender: Any) {
        showActionSheet(img: "2")
    }
    
    @IBAction func uberattech(_ sender: Any) {
        showActionSheet(img: "3")
    }
    @IBAction func btnnextaction(_ sender: Any) {
        
        let image = UIImage()
        if(imgstr1 == UIImage(named:"")){
            let alert = UIAlertController(title: nil, message: "Please upload driver license", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(imgstr2 == UIImage(named:"")){
            let alert = UIAlertController(title: nil, message: "Please upload driver insurance", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
//        else  if(imgstr3 == UIImage(named:"")){
//            let alert = UIAlertController(title: nil, message: "Please select driver home insurance", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else  if(imgstr4 == UIImage(named:"")){
//            let alert = UIAlertController(title: nil, message: "Please Enter City", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
            
        else
        {
            
            
            StartSpinner()
            
            let maximumSize : CGFloat = 400*400
            var compressRatio = CGFloat()
            let imageSize1 : CGFloat = self.imgstr1!.size.width * self.imgstr1!.size.height
            let imageSize2: CGFloat = self.imgstr2!.size.width * self.imgstr2!.size.height
           
            var imageSize3 :CGFloat = 0.0
            var imageSize4 :CGFloat = 0.0
           
            if self.isImage3Set{
                imageSize3  = self.imgstr3!.size.width * self.imgstr3!.size.height

            }
            if self.isImage4Set{
                imageSize4  = self.imgstr4!.size.width * self.imgstr4!.size.height

            }
            
//            if imageSize1 < maximumSize {
//                compressRatio = 1
//            }
//
//            else {
//                compressRatio = maximumSize / imageSize1
//            }
//            if imageSize2 < maximumSize {
//                compressRatio = 1
//            }
//
//            else {
//                compressRatio = maximumSize / imageSize2
//            }
//            if imageSize3 < maximumSize {
//                compressRatio = 1
//            }
//
//            else {
//                compressRatio = maximumSize / imageSize3
//            }
//            if imageSize4 < maximumSize {
//                compressRatio = 1
//            }
//
//            else {
//                compressRatio = maximumSize / imageSize4
//            }
            
            
            let img1 =   self.imgstr1?.fixOrientation()
            let img2 =   self.imgstr2?.fixOrientation()

            var image1 = UIImageJPEGRepresentation(img1!, 0.5)!.base64EncodedString(options: .lineLength64Characters)
            var image2 = UIImageJPEGRepresentation(img2!, 0.5)!.base64EncodedString(options: .lineLength64Characters)
            var image3:String = ""
            var image4:String = ""

            if self.isImage3Set{
                var img3 =   self.imgstr3?.fixOrientation()

                image3 = UIImageJPEGRepresentation(img3!, 0.5)!.base64EncodedString(options: .lineLength64Characters)

            }
            if self.isImage4Set{
                var img4 =   self.imgstr4?.fixOrientation()

                image4 = UIImageJPEGRepresentation(img4!, 0.5)!.base64EncodedString(options: .lineLength64Characters)

            }
            
            
            
            var parmm:Parameters = [
                
                "driving_license":image1,
                "insurance_card":image2,
                
                ]
            
            if isImage3Set{
                parmm["home_insurance"] = image3
            }
            if isImage4Set{
                 parmm["current_driver"] = image4
            }
            
            
            
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            StartSpinner()
            Alamofire.request(WebServiceClass().BaseURL + "driver/update/document_base64", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSONDecodable { (response:DataResponse<UploadDocsResponse>) in
                switch response.result{
                case .success(let resp):
                    StopSpinner()
                    //if success then lets save userprofile to defaults
                    Defaults[.profileStatusKey] = resp.data.profileStatus!
                    Defaults.synchronize()
                    print("updated profileStatus is : \(Defaults[.profileStatusKey])")
                    print(resp)
                    if resp.errorCode == 0{
                        let alert = AlertBuilder(title: "Success", message: resp.message)
//                        self.present(alert, animated: true, completion: nil)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverbankViewController") as! DriverbankViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        let alert = AlertBuilder(title: "oops", message: resp.message)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    //lets push him to another screen
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    StopSpinner()

                    let alert = AlertBuilder(title: "oops", message: "Could Not Upload Documents \n Try Again ")
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
            
            //                            if(dic.value(forKey: "error_code") as! NSNumber == 0)
            //                            {
            //
            //                                var datadic :NSDictionary = dic.value(forKey: "data") as! NSDictionary
            //                                let profilestatus = datadic.value(forKey: "profilestatus") as! NSNumber
            //
            //                                let user = UserDefaults.standard
            //
            //                                user.set(profilestatus.stringValue, forKey: "profilestatus")
            //                                user.synchronize()
            //
            //
            //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverbankViewController") as! DriverbankViewController
            //                                self.navigationController?.pushViewController(vc, animated: true)
            //
            //                            }
            //                            else
            //                            {
            //                                let alert = UIAlertController(title: nil, message:dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
            //                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            //                                self.present(alert, animated: true, completion: nil)
            //
            //                            }
            
            
            //                        case .failure(let error):
            //            StopSpinner()
            
            //                            if error._code == NSURLErrorTimedOut {
            //                                //HANDLE TIMEOUT HERE
            //                            }
            //                            print("\n\nAuth request failed with error:\n \(error)")
        }
        
        
        
        
        
        
    }
    
    //                    StopSpinner()
    
    //                    if error._code == NSURLErrorTimedOut {
    //                        let alert = UIAlertController(title: nil, message: "Request Timeout", preferredStyle: UIAlertControllerStyle.alert)
    //                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    //                        self.present(alert, animated: true, completion: nil)                }
    
    //                    print("Error in upload: \(error.localizedDescription)")
    
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}



