//
//  NewHelpVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 6/6/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import  Alamofire

class NewHelpVC: UIViewController,UITableViewDelegate , UITableViewDataSource {

    
    @IBOutlet weak var tblview: UITableView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    
    var triphisoryary = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        gettriphisotry()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return triphisoryary.count
        
 
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RidehistoryVC") as! RidehistoryVC
        
        let dic: NSDictionary = self.triphisoryary.object(at: indexPath.row) as! NSDictionary
        
        nextViewController.driverdic = dic
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell: Amountcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Amountcell
        cell.view.layer.cornerRadius = 12.0
        let dic: NSDictionary = self.triphisoryary.object(at: indexPath.row) as! NSDictionary
        
        cell.lbldatetime.text = dic.value(forKey:"created_at") as! String
        
        let time = dic.value(forKey: "total_estimated_travel_time") as? String
        cell.lbltotaltime.text = time! + ""
        
        
        
        
        if let cost =  dic.value(forKey: "total_estimated_trip_cost") as? Double
            
        {
            
            cell.lblcost.text =  "$ " +  String(format: "%.2f",cost)
            
        }
        else
        {
            cell.lblcost.text =  "$ 0"
            
            
        }
        
        
        return cell
        
        
        
    }
    
    func gettriphisotry()
    {
        if AppDelegate.hasConnectivity() == true
        {
            
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            StartSpinner()
            // print(txtmobilenumber.text!)
            
            
            Alamofire.request(WebServiceClass().BaseURL+"driver/get/triphistory", method: .post, parameters:[:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(response.result.value!)
                        
                        StopSpinner()
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            let ary : NSArray = dic.value(forKey:"data") as! NSArray
                            
                            
                            let new = ary.reversed() as! NSArray
                            self.triphisoryary = new.mutableCopy() as! NSMutableArray
                            
                            self.tblview.reloadData()
                            if(self.triphisoryary.count == 0)
                            {
                                
                                self.height.constant = 0
                                
                            }
                            else{
                                self.height.constant = 100
                                
                                
                                
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
    @IBAction func back_action(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
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
