//
//  DriverpersonalinfoViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/11/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class DriverpersonalinfoViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtfname: UITextField!
    
    @IBOutlet weak var txtmname: UITextField!
    
    @IBOutlet weak var txtlname: UITextField!
    
    @IBOutlet weak var txtnumber: UITextField!
    @IBOutlet weak var txtdob: UITextField!
    let datePicker = UIDatePicker()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        txtfname.becomeFirstResponder()
    }
    @IBAction func txtbtnaction(_ sender: Any) {
        if(txtfname.text == "")
        {
            
            let alert = UIAlertController(title: nil, message: "Please enter firstname", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
       
        else if(txtlname.text == "")
        {
            
            let alert = UIAlertController(title: nil, message: "Please enter lastname", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else if(txtnumber.text == ""){
            
            let alert = UIAlertController(title: nil, message: "Please enter security number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if(txtdob.text == ""){
            let alert = UIAlertController(title: nil, message: "Please enter date of birth", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
           checkinfo()
          
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        
        let str1 = textField.text as NSString?
        let newString = str1?.replacingCharacters(in: range, with: string)
     
        
         if(textField == txtnumber)
         {
            if (isBackSpace == -92) {
                // print("Backspace was pressed")
            }
            else if newString?.characters.count == 5 || newString?.characters.count == 8 {
                textField.text = textField.text! + "-"
            }
            else if newString?.characters.count == 13 {
                return false
                
            }
        
        }
        
        return true
    }
    
    func checkinfo()
    {
        if AppDelegate.hasConnectivity() == true
        {
            
            StartSpinner()
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
           
            let parameters = [
                "legal_firstname":txtfname.text!,
                "legal_middlename": txtmname.text!,
                "legal_lastname": txtlname.text!,
                 "social_security_number": txtnumber.text!,
                  "dob": txtdob.text!
            ]
            
            Alamofire.request(WebServiceClass().BaseURL+"driver/update/personalinfo", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    StopSpinner()
                    if let data = response.result.value{
                        print("response from Personal Information")
                        print(response.result.value!)
                        var dic = response.result.value as! NSDictionary
                        
                        
                        
                        
                        if(dic.value(forKey: "error_code") as! NSNumber == 0)
                        {
                            
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DrivershippingaddViewController") as! DrivershippingaddViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        var dic = response.result.value as! NSDictionary
                        var datadic :NSDictionary = dic.value(forKey: "data") as! NSDictionary
                        let profilestatus = datadic.value(forKey: "profile_status") as! Int
                        let status = profilestatus as! NSNumber
                        
                        let user = UserDefaults.standard
                        print(status.stringValue)
                        user.set(status.stringValue, forKey: "profile_status")
                        user.set(self.txtfname.text!, forKey: "firstname")
                        user.set(self.txtmname.text!, forKey: "middlename")
                        user.set(self.txtlname.text!, forKey: "lastname")
                        user.set(self.txtnumber.text!, forKey: "securitynum")
                        user.set(self.txtdob.text!, forKey: "dob")
                        user.set(profilestatus, forKey: "profilestatus")

                        user.synchronize()
                        }
                        else
                        {
                            let alert = UIAlertController(title: nil, message: dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
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
    func showDatePicker(){
        
        
        //minimum age 16
        let currentDate = Date()
        let oneDay = 24 * 3600 * 365
//        let minDate = currentDate.addingTimeInterval(TimeInterval(-10 * oneDay)) // before 10 days from now
        let maxDate = currentDate.addingTimeInterval(TimeInterval(-18 * oneDay)) // upto 20 Days from now
        datePicker.maximumDate = maxDate

        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donedatePicker));
        
        toolbar.setItems([doneButton], animated: false)
        
        txtdob.inputAccessoryView = toolbar
        txtdob.inputView = datePicker
        
        
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtdob.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }



}
