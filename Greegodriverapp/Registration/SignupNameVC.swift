//
//  SignupNameVC.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/7/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit

class SignupNameVC: UIViewController {
    
    
    
    @IBOutlet weak var txtfname: UITextField!
    
    
    @IBOutlet weak var txtlname: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: txtfname.frame.size.height - width, width:  txtfname.frame.size.width, height: txtfname.frame.size.height)
        
        border.borderWidth = width
        txtfname.layer.addSublayer(border)
        txtfname.layer.masksToBounds = true
        
        let border1 = CALayer()
        let width1 = CGFloat(2.0)
        border1.borderColor = UIColor.darkGray.cgColor
        border1.frame = CGRect(x: 0, y: txtlname.frame.size.height - width1, width:  txtlname.frame.size.width, height: txtlname.frame.size.height)
        
        border1.borderWidth = width1
        txtlname.layer.addSublayer(border1)
        txtlname.layer.masksToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnbackaction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextbtnaction(_ sender: Any) {
        
        if(txtfname.text == "")
        {
            
            let alert = UIAlertController(title: nil, message: "Please enter firstname", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
        else  if(txtlname.text == "")
        {
            
            let alert = UIAlertController(title: nil, message: "Please enter lastname", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
        else
        {
            
            let user = UserDefaults.standard
            
            user.set(txtfname.text!, forKey: "fname")
            user.set(txtlname.text!, forKey: "lname")
            
            user.synchronize()
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromocodeViewController") as! PromocodeViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

