//
//  EarningVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/18/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//



import UIKit
import Kingfisher
import SwiftyUserDefaults
import SVProgressHUD
import Alamofire


class EarningVC: UIViewController, UITableViewDelegate , UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var lblBalanceAmmount: UILabel!
    
    @IBOutlet weak var aCollectionView: UICollectionView!
    
    @IBOutlet weak var imguser: UIImageView!
    
    @IBOutlet weak var payoutview: UIView!
    
    @IBOutlet weak var tblview: UITableView!
    
    @IBOutlet weak var btnOnOff: UIImageView!

    var triphisoryary = NSMutableArray()
    var weeekdays = NSMutableArray()
    var totalcost: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        aCollectionView.layer.borderWidth = 2.0
        aCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        payoutview.layer.cornerRadius = 12.0
        
        
        imguser.layer.borderWidth=1.0
        imguser.layer.masksToBounds = false
        imguser.layer.borderColor = UIColor.white.cgColor
        imguser.layer.cornerRadius = imguser.frame.size.height/2
        imguser.clipsToBounds = true
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        imguser.addGestureRecognizer(tap)
        if revealViewController() != nil
        {
          //  view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getDriverInfoAndUpdateThisView()
        
        if Defaults[.isOnOffBtnON]{
            btnOnOff.image = #imageLiteral(resourceName: "ON")
            
        }else{
            btnOnOff.image = #imageLiteral(resourceName: "OFF")
        }
        gettriphisotry()
        
        self.totalcost = 0
        let image = Defaults[.profileImageString]
        let resource = ImageResource(downloadURL: URL(string: image)!)
        
        imguser.kf.setImage(with: resource, placeholder: UIImage(named:"download"), options: nil, progressBlock:nil, completionHandler: nil)
        
    }
    
    func updateNotificationVIew(with profiledata:DriverMeResonse){
        
        if profiledata.errorCode == 0{
            if let profileLevel = profiledata.data.profileStatus{
                Defaults[.profileStatusKey] = profileLevel
                if profileLevel < 7{
                    //incomplete information
                   
                    imguser.isUserInteractionEnabled = false
                    
                }else if profileLevel == 7 && profiledata.data.isApprove! == 0{
                    // under Review
             
                    imguser.isUserInteractionEnabled = false
                   // view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

                    
                    
                }else if profileLevel == 7 && profiledata.data.isApprove! != 0{
                    //NO Notifications
                
                    imguser.isUserInteractionEnabled = true
                    view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

                    
                    
                }
            }
        }else{
            print("there is an error")
        }
    }
    func getDriverInfoAndUpdateThisView(){
        //TODO: Yet to Test
        StartSpinner()
        let token = Defaults[.deviceTokenKey]
        let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
        print(token)
        
        
        Alamofire.request(WebServiceClass().BaseURL + "driver/me", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSONDecodable(completionHandler: { (dataresponse:DataResponse<DriverMeResonse>) in
            switch dataresponse.result{
            case .success(let resp):
                print("got Driver Info")
                print(resp)
                DriverMe = resp
                
                Defaults[.Driverid] = resp.data.id ?? 0
                self.updateNotificationVIew(with: resp)
            
            
                StopSpinner()
                
            case .failure(let err):
                print(err.localizedDescription)
                StopSpinner()
                
            }
        })
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return triphisoryary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell: Amountcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Amountcell
        cell.view.layer.cornerRadius = 12.0
        let dic: NSDictionary = self.triphisoryary.object(at: indexPath.row) as! NSDictionary
        
        cell.lbldatetime.text = dic.value(forKey:"created_at") as! String
        
        let time = dic.value(forKey: "total_estimated_travel_time") as? NSNumber
        cell.lbltotaltime.text = (time?.stringValue)! + " Minutes"
        
        
        
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RidehistoryVC") as! RidehistoryVC
        
        let dic: NSDictionary = self.triphisoryary.object(at: indexPath.row) as! NSDictionary
        
        nextViewController.driverdic = dic
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var dvc:Payoutdetailcell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! Payoutdetailcell
        
        
        if(indexPath.row == 0)
        {
            var num = 0
            var cost: Double = 0
            if(todayary.count > 0)
            {
                for var i in 0...self.todayary.count-1
                {
                let dic: NSDictionary = self.todayary.object(at: i) as! NSDictionary
                
                
                
                var num1 : NSNumber = 0
                
                if let b = dic.value(forKey:"total_estimated_travel_time") as? NSNumber{
                    num1 = b
                }
                
                var cost1:Double = 0
                
                if let a = dic.value(forKey:"total_estimated_trip_cost") as? Double{
                    cost1 = a
                }
                    let finalnum = num1.intValue

                    cost = cost + cost1
                    num = num + finalnum
                }
                
                dvc.lblamount.text =  "$ " + String(format:"%.2f", cost)
                dvc.lbltime.text = String(num) + " minutes"
                
            }
            
            dvc.lblday.text = "Today"
            dvc.lblnumrides.text = String(todayary.count)
            
        }
        if(indexPath.row == 1)
        {
            var num = 0
            var cost: Double = 0
            if(self.finaldateary.count > 0)
            {
                for var i in 0...self.finaldateary.count-1
                {
                    let dic: NSDictionary = self.finaldateary.object(at: i) as! NSDictionary
                    
               
                    var num1 : NSNumber = 0
                    
                    if let b = dic.value(forKey:"total_estimated_travel_time") as? NSNumber{
                        num1 = b
                    }
                    
                    var cost1:Double = 0
                    
                    if let a = dic.value(forKey:"total_estimated_trip_cost") as? Double{
                        cost1 = a
                    }
                    
                    //
                    
                    
                    let finalnum = num1.intValue
                    
                    cost = cost + cost1
                    num = num + finalnum
                }
                
                dvc.lblamount.text =   "$ " + String(format:"%f", cost)
                dvc.lbltime.text = String(num) + " minutes"
                dvc.lblnumrides.text = String(self.finaldateary.count)
               
            }
            
            dvc.lblday.text = "Weekly"
        }
        
        return dvc
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    
    var finaldateary = NSMutableArray()
    var todayary = NSMutableArray()
    
    
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
                            let calendar = Calendar.current
                            let today = calendar.startOfDay(for: Date())
                            let dayOfWeek = calendar.component(.weekday, from: today)
                            let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
                            
                            let days = (weekdays.lowerBound ..< weekdays.upperBound)
                                .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }  // use `flatMap` in Xcode versions before 9.3
                                .filter { !calendar.isDateInWeekend($0) }
                            let daysary = NSMutableArray()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "YYYY-MM-dd"
                            for day in days
                            {
                                let newdate = dateFormatter.string(from: day)
                                print(newdate)
                                daysary.add(newdate)
                                
                                
                                
                            }
                            
                            if(self.finaldateary.count > 0)
                            {
                                
                                self.finaldateary.removeAllObjects()
                                
                            }
                            if(self.todayary.count > 0)
                            {
                                
                                self.todayary.removeAllObjects()
                                
                            }
                            if(self.triphisoryary.count > 0)
                            {
                            for var i in  0...self.triphisoryary.count-1
                            {
                                
                                
                                let dic1: NSDictionary = self.triphisoryary.object(at: i) as! NSDictionary
                                
                                
                                var date = dic1.value(forKey:"created_at") as! String
                              
                               // dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                                
                                var fullname = dic1.value(forKey:"created_at") as! String
                                
                                let first = fullname.components(separatedBy: " ").first
                                
                                let newdate = dateFormatter.date(from:first!)
                               
                                let today = dateFormatter.string(from: Date())

                           
                                
                                if(dic1.value(forKey: "payout_status") as! NSNumber == 0)
                                {
                                
                                    var amount = dic1.value(forKey:"total_estimated_trip_cost") as? Double
                                    
                                    if(amount != nil)
                                    {
                                    self.totalcost = self.totalcost + amount!
                                  
                                    }

                                   
                                }
                              
                                
                                if(daysary.contains(first!))
                                {
                                    self.finaldateary.add(dic1)

                                }
                                
                                

                                if(today == first)
                                {
                                   self.todayary.add(dic1)
                                    
                                    
                                }
                                
                                
                            }
                                self.aCollectionView.reloadData()


                                self.lblBalanceAmmount.text =  "$ " + String(format:"%.2f", self.totalcost)
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
    
    
    
    
    @IBAction func btnGetpaid(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpressPayVC") as! ExpressPayVC
        
        vc.payoutAmmount = totalcost
        self.navigationController?.pushViewController(vc, animated: true)
    
    
        
        
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
