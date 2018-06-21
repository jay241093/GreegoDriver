//
//  DrivemapVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/17/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import GooglePlaces
import SwiftyUserDefaults
import Alamofire
import Kingfisher
import SwiftyJSON
import AVFoundation



var reveal = SWRevealViewController()
var DriverMe :DriverMeResonse?

class DrivemapVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnOnOff: UIImageView!
    
    @IBOutlet weak var userMapView: GMSMapView!
    
    @IBOutlet weak var btnprofilecheck: UIButton!
    
    
    @IBOutlet weak var heightview: NSLayoutConstraint!
    
    
    @IBOutlet weak var imgerror: UIImageView!
    
    @IBOutlet weak var line2: UILabel!
    
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var lblstatus: UILabel!
    
    
    @IBOutlet weak var viewNewUpdate: UIView!
    
    @IBOutlet weak var btnFinishApplication: UIButton!
    
    var profilestatus: NSNumber?
    var locationManager = CLLocationManager()
    var latLatest = CLLocationDegrees()
    var longLatest = CLLocationDegrees()
    
    private var tenSecTimer = Timer()
    
    
    var isNewUpdateViewOpen:Bool = false
    var shouldOpenUpdateView = true
    var shouldShowFinishButton = true
    var isOnOffBtnON:Bool = true
     var  userLocation = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNewUpdate.isHidden = true

        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json")
            {
                userMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        
        isOnOffBtnON = Defaults[.isOnOffBtnON]
         //initDefaults()
        Defaults[.isAleradyLoggedIn] = true
        //request device and user to provide current location with specified accuracy
        StartLocationUpdateInDevice()
        
        //Start Continious Update
        toggleLocationUpdatesToServer(toggle: true)
        
        //Send myLocationTo Server once
        SendMyLocationToServer()
        toggleLocationUpdatesToServer(toggle: true)
  initViews()
                
    }
    
    @objc func ApprovedRequest(note:Notification){
//        let alert = AlertBuilder(title: "Congratulations", message: "Application Approved \nYou are now a GreegoDriver")
//        let alert = uialert
        let alert2 = UIAlertController(title: "Congratulations", message: "Your Driver Application is Approved", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.viewDidAppear(false)
            var parmm:Parameters = [:]

            parmm = [
                "driver_on":1,
            ]
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            Alamofire.request(WebServiceClass().BaseURL + "driver/update/device", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response:DataResponse<Any>) in
                switch response.result{
                case .success(let resp):
                    //print(resp)
                  
                        self.btnOnOff.image = #imageLiteral(resourceName: "OFF")
                        self.isOnOffBtnON = false
                        Defaults[.isOnOffBtnON] = false
                        
                        
                    
                case .failure(let err):
                    print(err)
                    print("Failed to change ")
                    let alert = AlertBuilder(title: "OOps", message: "Unable to Change Driver Status \n Try Again")
                    self.present(alert, animated: true, completion: nil)
                    StopSpinner()
                    
                    
                }
                
             
            }
            
            
        }
        
        alert2.addAction(OkAction)
        present(alert2, animated: true, completion: nil)
    }
    @objc func Rejectedrequst(note:Notification){
     
        let alert2 = UIAlertController(title: "Oops", message: "Your Driver Application is Rejected", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.viewDidAppear(false)
            self.imgProfilePic.isUserInteractionEnabled = false
            self.btnOnOff.isUserInteractionEnabled = false
        }
        
        alert2.addAction(OkAction)
        present(alert2, animated: true, completion: nil)
    }
    
    @objc func AcceptRequest(note:Notification)
    {
        
        if reveal.frontViewPosition == FrontViewPosition.right {
            reveal.revealToggle(animated: true)
            
        }
        if let wd = UIApplication.shared.delegate?.window {
            var vc = wd!.rootViewController
            if(vc is UINavigationController){
                vc = (vc as! UINavigationController).visibleViewController
                
            }
            
            if(vc is RequestDriverVC){
                //your code
            }
            else
            {
                AudioServicesPlayAlertSound(SystemSoundID(1322))
                
                //close the sidebar if already open
                
                //        if reveal.frontViewPosition == FrontViewPosition.right {
                //            reveal.revealToggle(animated: true)
                //
                //        }
                
                let jsonObj = JSON(note.userInfo!)
                
                //        if jsonObj["request_id"] as Int !=
                
                let  requestID = jsonObj["request_id"].intValue
                print("received a request====\(requestID)")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let RequestDriverViewController = storyBoard.instantiateViewController(withIdentifier: "RequestDriverVC") as! RequestDriverVC
                RequestDriverViewController.requestID = requestID
                self.navigationController?.pushViewController(RequestDriverViewController, animated: true)
                
            }
        }
        
        
     
        
    }
    
    
    
    
    
    
    //            let destination  = segue.destination as! RequestDriverVC
    //            destination.requestID = sender as! Int
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //received notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Approved"), object: nil)

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       isOnOffBtnON =  Defaults[.isOnOffBtnON]

        super.viewDidAppear(true)
        
        
        
        if isOnOffBtnON{
            btnOnOff.image = #imageLiteral(resourceName: "ON")
            
        }else{
            btnOnOff.image = #imageLiteral(resourceName: "OFF")
        }
        //received notification
        NotificationCenter.default.addObserver(self, selector:  #selector(AcceptRequest), name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)
       
        NotificationCenter.default.addObserver(self, selector:  #selector(ApprovedRequest), name: NSNotification.Name(rawValue: "Approved"), object: nil)

        NotificationCenter.default.addObserver(self, selector:  #selector(Rejectedrequst), name: NSNotification.Name(rawValue: "Rejected"), object: nil)

      
        
        if revealViewController() != nil
        {
            
         
            
        }
        
        let currentProfileStatus  = Defaults[.profileStatusKey]
        switch currentProfileStatus {
        case 1:
            btnprofilecheck.isHidden = true
            lblstatus.text = "Your profile is 14% complete"
            shouldOpenUpdateView = true
            
        case 2:
            btnprofilecheck.isHidden = true
            lblstatus.text = "Your profile is  28% complete"
            shouldOpenUpdateView = true
        case 3:
            btnprofilecheck.isHidden = true
            lblstatus.text = "Your profile is 42% complete"
            shouldOpenUpdateView = true
        case 4:
            btnprofilecheck.isHidden = true
            lblstatus.text = "Your profile is  56% complete"
            shouldOpenUpdateView = true
        case 5:
            btnprofilecheck.isHidden = true
            lblstatus.text = "Your profile is  70% complete"
            shouldOpenUpdateView = true
        case 6:
            btnprofilecheck.isHidden = true
            lblstatus.text = "Your profile is 84% complete"
            shouldOpenUpdateView = true

        case 7:
            if Defaults[.isAprrovedKey] == 0{
                btnprofilecheck.isHidden = true
                lblstatus.text = "Your Application is on under review"
                shouldOpenUpdateView = true
            }
        default:
            btnprofilecheck.isHidden = true
            lblstatus.text = "No New Updates"
            shouldOpenUpdateView = false
            
        }
        
        getDriverInfoAndUpdateThisView()
        
    }
    
    
    func initViews(){
        line2.isHidden = true
        line1.isHidden = true
        imgerror.isHidden = true
        lblstatus.isHidden = true
        btnFinishApplication.isHidden = true
        btnFinishApplication.layer.cornerRadius = 18.0
        
        heightview.constant = 62
        
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height/2
        imgProfilePic.layer.masksToBounds = true
        
        
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        
    
        imgProfilePic.addGestureRecognizer(tap)
        
        viewNewUpdate.layer.shadowColor = UIColor.lightGray.cgColor
        viewNewUpdate.layer.shadowOpacity = 0.5
        viewNewUpdate.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewNewUpdate.layer.shadowRadius = 2
        viewNewUpdate.layer.cornerRadius = 12.0
        
        
        
        //check if onButton is On and set a var
        if btnOnOff.image == #imageLiteral(resourceName: "ON.png") {
            isOnOffBtnON = true
        }
        else if btnOnOff.image == #imageLiteral(resourceName: "OFF"){
            isOnOffBtnON = false
        }
        
        if heightview.constant > 62 {
            isNewUpdateViewOpen = true
        }
        else{
            isNewUpdateViewOpen = false
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - IBAction Methods
    
    @IBAction func OnOffButtonAction(_ sender: UITapGestureRecognizer) {
        print("on Off Button Tapped")
       
        
        
        
        var parmm:Parameters = [:]
        if Defaults[.isOnOffBtnON] {
            var refreshAlert = UIAlertController(title: "Greego", message: "Are you sure you want to change from OFF to ON?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                parmm = [
                    "driver_on":1,
                ]
                let token = Defaults[.deviceTokenKey]
                let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
                
                Alamofire.request(WebServiceClass().BaseURL + "driver/update/device", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response:DataResponse<Any>) in
                    switch response.result{
                    case .success(let resp):
                        //print(resp)
                        if self.isOnOffBtnON {
                            self.btnOnOff.image = #imageLiteral(resourceName: "OFF")
                            self.isOnOffBtnON = false
                            Defaults[.isOnOffBtnON] = false
                            
                            
                        }else {
                            self.btnOnOff.image = #imageLiteral(resourceName: "ON")
                            self.isOnOffBtnON = true
                            Defaults[.isOnOffBtnON] = true
                            
                            
                        }
                    case .failure(let err):
                        print(err)
                        print("Failed to change ")
                        let alert = AlertBuilder(title: "OOps", message: "Unable to Change Driver Status \n Try Again")
                        self.present(alert, animated: true, completion: nil)
                        StopSpinner()
                        
                        
                    }
                    
                    
                    
                    //
                    
                    
                    
                }            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
          
            
            
        }else{
            
            var refreshAlert = UIAlertController(title: "Greego", message: "Are you sure you want to change from ON to OFF?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                parmm = [
                    "driver_on":0,
                ]
                
                let token = Defaults[.deviceTokenKey]
                let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
                
                Alamofire.request(WebServiceClass().BaseURL + "driver/update/device", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response:DataResponse<Any>) in
                    switch response.result{
                    case .success(let resp):
                       // print(resp)
                        if self.isOnOffBtnON {
                            self.btnOnOff.image = #imageLiteral(resourceName: "OFF")
                            self.isOnOffBtnON = false
                            Defaults[.isOnOffBtnON] = false
                            
                            
                        }else {
                            self.btnOnOff.image = #imageLiteral(resourceName: "ON")
                            self.isOnOffBtnON = true
                            Defaults[.isOnOffBtnON] = true
                            
                            
                        }
                    case .failure(let err):
                        print(err)
                        print("Failed to change ")
                        let alert = AlertBuilder(title: "OOps", message: "Unable to Change Driver Status \n Try Again")
                        self.present(alert, animated: true, completion: nil)
                        StopSpinner()
                        
                        
                    }
                    
                    
                    
                    //
                    
                    
                    
                }            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
            
        }
        
        
        //if current img is on
        // when tapped ,send 1 to server
        // on successfull responce change image to off
       
      
    }
    @IBAction func btngoToMyLocation(_ sender: Any) {
        
        // move camera to my locaiton
        
    }
    
    @IBAction func NewUpdatesViewTapAction(_ sender: UITapGestureRecognizer) {
        
        //look is newUpdate view is open and togle it if user taps anywhere in this view
        //get state of each thing
  
        if isNewUpdateViewOpen  {
            line2.isHidden = true
            line1.isHidden = true
            imgerror.isHidden = true
            lblstatus.isHidden = true
            btnFinishApplication.isHidden = !shouldShowFinishButton
            heightview.constant = 62
            isNewUpdateViewOpen = false
        }
        else if !isNewUpdateViewOpen {
            line2.isHidden = false
            line1.isHidden = false
            imgerror.isHidden = false
            lblstatus.isHidden = false
            btnFinishApplication.isHidden = !shouldShowFinishButton
           // heightview.constant = 190
            if(shouldShowFinishButton == false)
            {
                heightview.constant = 110
                line2.isHidden = false
                line1.isHidden = false
                
            }
            else
            {
               heightview.constant = 190
            }
            isNewUpdateViewOpen = true
            
        }
    }
    
    
    
    @IBAction func erroraction(_ sender: Any) {
        
        
        line2.isHidden = false
        line1.isHidden = false
        imgerror.isHidden = false
        lblstatus.isHidden = false
        btnFinishApplication.isHidden = !shouldShowFinishButton
        viewNewUpdate.isHidden = true
        heightview.constant = 190
        
    }
    
    @IBAction func finishaction(_ sender: Any) {
        
        let profileStatus = Defaults[.profileStatusKey]
        
        
        let status = profileStatus
        print(status)
        if(status == 1)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverpersonalinfoViewController") as! DriverpersonalinfoViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        else if(status == 2)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DrivershippingaddViewController") as! DrivershippingaddViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        else if(status == 3)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverdocumentViewController") as! DriverdocumentViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
       else if(status == 4)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverbankViewController") as! DriverbankViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
      else  if(status == 5)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DrivertypeViewController") as! DrivertypeViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
       else if(status == 6)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverprofileViewController") as! DriverprofileViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
       else if(status == 7)
        {
            
            
        }
        
        else
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
    }
    
    
    //MARK: - Location Methods
    
    
    func StartLocationUpdateInDevice()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" , Error.self)
        
    }
    
    
    
    private func toggleLocationUpdatesToServer(toggle: Bool) {
        if toggle {
            tenSecTimer = Timer.scheduledTimer(timeInterval: 10,
                                               target:self,
                                               selector: #selector(DrivemapVC.SendMyLocationToServer),
                                               userInfo: nil, repeats: true)

            locationManager.startUpdatingLocation()
            //            startButton.setTitle("STOPPA", forState: UIControlState.Normal)
            //            startButton.backgroundColor = UIColor.redColor()
        }
        else {
            tenSecTimer.invalidate()
            locationManager.stopUpdatingLocation()
            //            startButton.setTitle("STARTA", forState: UIControlState.Normal)
            //            startButton.backgroundColor = UIColor.greenColor()
        }
    }
    
    //Sends current Device Location to server
    @objc func SendMyLocationToServer()
    {
        if AppDelegate.hasConnectivity() == true
        {
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
            let parameters:Parameters = [
                "lat" : latLatest,
                "lng" : longLatest,
                
                ]
            
            Alamofire.request(WebServiceClass().BaseURL + "driver/update/location", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (dataresponse:DataResponse<Any>) in
                switch dataresponse.result{
                case .success(let resp):
                    print("sent my location")
                   // print(resp)
                    
                case .failure(let err):
                    print(err.localizedDescription)
                }
            })
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
                //print(resp)
                DriverMe = resp
                
                Defaults[.Driverid] = resp.data.id ?? 0
                self.updateNotificationVIew(with: resp)
                if let profilepic = resp.data.profilePic{
                    if profilepic != ""{
                        self.setProfilePic(imgUrl: profilepic)
                        Defaults[.profileImageString] = profilepic
                        self.moveMapCameratoCurrent(coord: CLLocationCoordinate2D(latitude: self.latLatest, longitude: self.longLatest))
                        StopSpinner()
                    }
                    
                }else{
                    print("profilepic not yet uploaded")
                    StopSpinner()
                }
                StopSpinner()

            case .failure(let err):
                print(err.localizedDescription)
                StopSpinner()

            }
        })
    }
    //TODO: test
    func setProfilePic(imgUrl:String){
        let resource = ImageResource(downloadURL: URL(string: imgUrl)!)
        //imgProfilePic.kf.setImage(with: resource)
        imgProfilePic.kf.setImage(with: resource, placeholder: UIImage(named: "default-user"), options: nil, progressBlock: nil)

    }
    
    func updateNotificationVIew(with profiledata:DriverMeResonse){
        
        if profiledata.errorCode == 0{
            if let profileLevel = profiledata.data.profileStatus{
                Defaults[.profileStatusKey] = profileLevel
                if profileLevel < 7{
                    //incomplete information
                    //lblstatus.text = "Application is Incomplete"
                    btnprofilecheck.isHidden = false
                    shouldShowFinishButton = true
                    imgProfilePic.isUserInteractionEnabled = false
                    btnOnOff.isUserInteractionEnabled = false
                    viewNewUpdate.isHidden = false
                    self.tabBarController?.tabBar.isUserInteractionEnabled = false
                    
                    
                }else if profileLevel == 7 && profiledata.data.isApprove! == 0{
                    // under Review
                    lblstatus.text = "Application is Under Review"
                    btnprofilecheck.isHidden = false
                    shouldShowFinishButton = false
                    imgProfilePic.isUserInteractionEnabled = false
                   // view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                    btnOnOff.isUserInteractionEnabled = false
                     viewNewUpdate.isHidden = false
                    self.tabBarController?.tabBar.isUserInteractionEnabled = false



                    
                }
                
                
                    
                
                else if profileLevel == 7 && profiledata.data.isApprove! == 1{
                    //NO Notifications
                    lblstatus.text = "No New Updates"
                    btnprofilecheck.isHidden = true
                    shouldShowFinishButton = false
                    viewNewUpdate.isHidden = true
                    imgProfilePic.isUserInteractionEnabled = true
                    btnOnOff.isUserInteractionEnabled = true
                    view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                    self.tabBarController?.tabBar.isUserInteractionEnabled = true


                    
                }
                else if profileLevel == 7 && profiledata.data.isApprove! == 2{
                    self.imgProfilePic.isUserInteractionEnabled = false
                    self.btnOnOff.isUserInteractionEnabled = false
                    self.tabBarController?.tabBar.isUserInteractionEnabled = false

            }
        else{
            print("there is an error")
        }
         }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.userLocation = (locations.last?.coordinate)!
        self.userMapView.isMyLocationEnabled = true
        
        self.latLatest = userLocation.latitude
        self.longLatest = userLocation.longitude
        moveMapCameratoCurrent(coord: (locations.last?.coordinate)!)
        
        
        self.userMapView.settings.myLocationButton = true
      //  locationManager.stopUpdatingLocation()
    }
    
    func moveMapCameratoCurrent(coord:CLLocationCoordinate2D){
        let center = CLLocationCoordinate2D(latitude: coord.latitude , longitude: coord.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 15);
        self.userMapView.camera = camera
    }
    
}
