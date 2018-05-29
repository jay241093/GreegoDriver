//
//  PromocodeViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/11/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
import SwiftyJSON

class PromocodeViewController: UIViewController {
    
    @IBOutlet weak var txtfPromo: UITextField!
    
    @IBOutlet weak var promocodeview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setShadow(view: promocodeview)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_rectangle")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
    }
    
    
    
    func setShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 2
    }
    
    @IBAction func btnskipaction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermandconditionViewController") as! TermandconditionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        
        if txtfPromo.text! == ""{
            
            let alert = AlertBuilder(title:"Alert", message: "Please enter promo code")
         self.present(alert, animated: true, completion: nil)
            
        }else{
            
            
            
            
            let parmm:Parameters = ["promocode":txtfPromo.text!]
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
            
            Alamofire.request(WebServiceClass().BaseURL + "driver/verify/promocode", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (dataresponse) in
                
                switch dataresponse.result{
                    
                case .success(let resp):
                    print("promocode response")
                    print(resp)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermandconditionViewController") as! TermandconditionViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                  
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    let alert = AlertBuilder(title: "oops", message: "promocode is Invalid")
                }
            })
            
            
            
        }
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
