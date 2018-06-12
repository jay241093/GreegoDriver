//
//  ExpressPayVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/21/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Alamofire
import SVProgressHUD
import MapKit

class ExpressPayVC: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var btneditcard: UIButton!
    
    @IBOutlet weak var lbltotalamoint: UILabel!
    
    @IBOutlet weak var lblgreegofee: UILabel!
    
    
    @IBOutlet weak var lblexfees: UILabel!
    
    
    @IBOutlet weak var lblexfee: UILabel!
    
    
    let locationmanager = CLLocationManager()
    //payout ammount
    var payoutAmmount :Double = 0
    var greegoamount :Double = 0
    var Exfees :Double = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btneditcard.layer.shadowColor = UIColor.lightGray.cgColor
        btneditcard.layer.shadowOpacity = 0.5
        btneditcard.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btneditcard.layer.shadowRadius = 2
        btneditcard.layer.cornerRadius = 12.0
        getDriverInfoAndUpdateThisView()
        checkmobile()
        
        
        lbltotalamoint.text =  "$ " + String(format:"%.2f", payoutAmmount)
      
        StartLocationUpdateInDevice()
     
        
        // Do any additional setup after loading the view.
    }
    func StartLocationUpdateInDevice()
    {
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.requestAlwaysAuthorization()
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
   
        getStateNamefromCoord(coord: (locations.last?.coordinate)!) { (stateName) in
           getRateswithState(state: stateName, completion: { (rateResponse) in
                
              //  currentStaterates = rateResponse
            var greegofee =  (self.payoutAmmount * rateResponse.data.greegoFee!) / 100
            self.greegoamount = greegofee
            self.Exfees = rateResponse.data.expressFee!

            self.lblgreegofee.text = "-" + String(format:"%.2f", greegofee)
            self.lblexfee.text = "-" + String(format:"%.2f", rateResponse.data.expressFee!)
            self.lblexfees.text =  String(format:"%.2f", rateResponse.data.expressFee!)

            })
            
            print(stateName)
        }
        locationmanager.stopUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IBaction Methods
    @IBAction func closeaction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func getDriverInfoAndUpdateThisView(){
        //TODO: Yet to Test
        let token = Defaults[.deviceTokenKey]
        let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
        print(token)
        
        
        Alamofire.request(WebServiceClass().BaseURL + "driver/me", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSONDecodable(completionHandler: { (dataresponse:DataResponse<DriverMeResonse>) in
            switch dataresponse.result{
            case .success(let resp):
                print("got Driver Info")
               // print(resp)
                DriverMe = resp
                
                
                
                
                if let profilepic = resp.data.profilePic{
                    if profilepic != ""{
                        
                        
                    }
                    
                }else{
                    print("profilepic not yet uploaded")
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    func checkmobile()
    {
        if AppDelegate.hasConnectivity() == true
        {
            
            
            StartSpinner()
            // print(txtmobilenumber.text!)
          
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
            
            Alamofire.request(WebServiceClass().BaseURL+"driver/me", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                     
                        
                        StopSpinner()
                        
                        
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            let dic: NSDictionary = dic.value(forKey:"data") as! NSDictionary
                            
                            let bank_information: NSDictionary = dic.value(forKey:"bank_information") as! NSDictionary

                            let decodedData = Data(base64Encoded: bank_information.value(forKey: "account_number")as! String)!
                            let decodedString = String(data: decodedData, encoding: .utf8)!

                            
                            let last4 = String(decodedString.characters.suffix(4))

                            
                            
                            self.btneditcard.setTitle("Edit Visa (****" + last4 + ")" , for: .normal)
                           
                            
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
    
    
    
    
    //Do Express Pay
    func expresspayDo() {
        StartSpinner()
        if AppDelegate.hasConnectivity()
        {
            
            
            var totalamount = payoutAmmount - greegoamount - Exfees
            
            // print(txtmobilenumber.text!)
            
            
            let parmm:Parameters = ["pay_amount":totalamount,
                                    "driver_id":Defaults[.Driverid]
            ]
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
            print(headers)
            
            Alamofire.request(WebServiceClass().BaseURL + "driver/express/pay", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(let resp):
                    print(resp)
                    let dic: NSDictionary = response.result.value as! NSDictionary
                    StopSpinner()
                    
                    
                    if(dic.value(forKey: "error_code") as! NSNumber == 0)
                    {
                    
                    var refreshAlert = UIAlertController(title: nil, message:dic.value(forKey:"message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                    
                
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ExpressPayDetailVC") as! ExpressPayDetailVC
                        
                        nextViewController.totalfess = self.lbltotalamoint.text!
                        nextViewController.greegofess = self.lblgreegofee.text!
                        nextViewController.expressfees = self.lblexfee.text!

                        self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                        
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                    }
                    else
                    
                    {
                        
                     let alert = AlertBuilder(title:"", message: dic.value(forKey: "message") as! String)
                        self.present(alert, animated: true, completion: nil)

                        
                    }
                    
                case .failure(let err):
                    StopSpinner()
                    print(err.localizedDescription)
                    StopSpinner()
                    
                    
                }
            }
            
        }
        else
        {
            WebServiceClass().nointernetconnection()
            NSLog("No Internet Connection")
            StopSpinner()
           
        }
        
    }
    
   
    @IBAction func btnconfromaction(_ sender: Any) {
        
        expresspayDo()
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
