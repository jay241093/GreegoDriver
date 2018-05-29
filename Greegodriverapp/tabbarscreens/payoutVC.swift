//
//  payoutVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/19/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyUserDefaults

class payoutVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tblview: UITableView!
    
    
    var payoutary : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payoutdetails()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payoutary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PayoutActivityCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PayoutActivityCell
        
        
        let dic:NSDictionary = self.payoutary.object(at: indexPath.row) as! NSDictionary
        cell.lblcreated.text = dic.value(forKey:"created_at") as! String
        
        
        let actualamount = dic.value(forKey:"actual_trip_amount") as? Double
        let tip = dic.value(forKey:"tip_amount") as! Double
        
        let finalcost = actualamount! + tip
        
        
        cell.lblcost.text =  "$ " + String(finalcost)
        
        if(dic.value(forKey: "paid_type") as! NSNumber == 0)
        {
            cell.lblpayment.text = "Weekly Payment"
        }
        else
        {
            cell.lblpayment.text = "Express Payment"
            
        }
        return cell
        
        
        
    }
    
    // MARK: - IBaction
    
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        
        
        
    }
    
    func payoutdetails()
    {
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            // print(txtmobilenumber.text!)
            
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
            
            Alamofire.request(WebServiceClass().BaseURL+"driver/get/payout_history", method: .post, parameters:["driver_id":Defaults[.Driverid]], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        
                        
                        StopSpinner()
                        StopSpinner()
                        
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            let payoutdic: NSArray = dic.value(forKey: "data") as! NSArray
                            
                            self.payoutary = payoutdic.mutableCopy() as! NSMutableArray
                            
                           if(self.payoutary.count == 0)
                           {
                            let alert = AlertBuilder(title: "Greego", message: "No payout details found")
                            self.present(alert, animated: true, completion: nil)

                            
                            
                            }
                           else{
                            self.tblview.reloadData()
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
