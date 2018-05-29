
//
//  HelpplolicyVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 5/29/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class HelpplolicyVC: UIViewController {

    @IBOutlet weak var txtview: UITextView!

    @IBAction func back_action(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

         gettermscondition()
        // Do any additional setup after loading the view.
    }
    func gettermscondition()
    {
        
        if AppDelegate.hasConnectivity() == true
        {
            SVProgressHUD.show()
            
            
            Alamofire.request(WebServiceClass().BaseURL+"get/texts", method:.get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(response.result.value!)
                        
                        
                        SVProgressHUD.dismiss()
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            let newdic: NSDictionary = dic.value(forKey:"data") as! NSDictionary
                            let text = newdic.value(forKey:"service_animal_policy") as! String
                            let htmlData = NSString(string: text).data(using: String.Encoding.unicode.rawValue)
                            
                            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
                            
                            let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
                            
                            self.txtview.attributedText = attributedString
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    SVProgressHUD.dismiss()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
