//
//  RequestDriverVC.swift
//  GreeGo
//
//  Created by Pish Selarka on 19/04/18.
//  Copyright © 2018 Techrevere. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import SVProgressHUD
import PKHUD
import GooglePlaces
import Kingfisher

func getStateNamefromCoord(coord:CLLocationCoordinate2D, completion:@escaping (String)->Void){
    
    let geocoder = GMSGeocoder()
    geocoder.reverseGeocodeCoordinate(coord) { response , error in
        
        
        if error == nil{
            if let address = response!.firstResult() {
                
                
                print(address.administrativeArea ?? address.locality!)
                
                //
                completion(address.administrativeArea ?? address.locality!)
                
            }
            
        }else{
            print("Can not fetch  StateName from Coordinates")
        }
    }
    
}

func getRateswithState(state:String,completion:@escaping (StateRateResponse)->Void) -> Double {
    StartSpinner()
    
    let parmm = [
        "state": state
    ]
    
    let token = Defaults[.deviceTokenKey]
    let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
    
    Alamofire.request(WebServiceClass().BaseURL + "get/rates", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSONDecodable { (dataresponse:DataResponse<StateRateResponse>) in
        switch dataresponse.result{
        case .success(let resp):
            StopSpinner()
            print("response from get state rate")
            print(resp)
            completion(resp)
        case .failure(let err):
            StopSpinner()
            print(err.localizedDescription)
            print("Could not  get Rates from state")
            let alert = AlertBuilder(title: "oops", message: "Could Not get rates from state")
        }
    }
    
    StopSpinner()
    
    return 0.0
}

var requestDetailsResponse:RequestDetailsResponse?

class RequestDriverVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,comfirmm,ConfirmDropOffDelegate,popUpNavigateProtocol,callPopUpProtocol,CloseActionDelegate{
   
    
    
    var timer1  = Timer()
    var timer2  = Timer()

    
    var firstupdate = 0
    //MARK:- IBOutlet
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var lblCountDown: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var imgViewPin: UIImageView!
    @IBOutlet weak var imgProfilePicOnButton: UIImageView!
    
    
    @IBOutlet weak var lblNameOfUser: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblCarName: UILabel!
    
    @IBOutlet weak var btnTapToBeDriver: UIButton!
    @IBOutlet weak var btnCallUser: UIButton!
    
    @IBOutlet weak var navigationIconWidth: NSLayoutConstraint!
    @IBOutlet weak var CountDownIconWidth: NSLayoutConstraint!
    @IBOutlet weak var ViewWithProfileImgWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var ViewWithUsernameAndPic : UIView!
    @IBOutlet weak var ViewWithUsernameAndPicWidth: NSLayoutConstraint!
    
    
    
    
    
    //-----------------------------------------
    //MARK:- Property
    var locationManager = CLLocationManager()
    var centerMapCoordinate:CLLocationCoordinate2D!
    var sourceCord = CLLocationCoordinate2D()
    var destCord = CLLocationCoordinate2D()
    var sourceMarker = GMSMarker()
    var destMarker = GMSMarker()
    var seconds = 60
    var timer = Timer()
    var timerForPathDraw = Timer()
    var isTimingRunning = false
    var nameOfUser = ""
    var requestID = 0
    var timershouldStop = false
    var currentAddressText = ""
    var userMobileNumber = ""
    var userprofileImageString = ""
    var estimatedAmmount = 0.0
    let viewWithProfImgWidthConstant : CGFloat = 51.13
    
    var tripStartTime:Date?
    var tripEndTime:Date?
    var tripTimeInterval : Double?
    var totalTripDistance: Double?
    var actualTripPrice : Double = 0.0
    
    var stateRates:StateRateResponse?
    
    //MARK:- VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        //
        print(Defaults[.deviceTokenKey])
        
        //
        print("the request id is \(requestID)")
        
        imgProfilePicOnButton.isHidden = true
        getDataAboutRequestAndPopulateIt(request: requestID)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:  #selector(TripCanceled), name: NSNotification.Name(rawValue: "cancelled"), object: nil)

        
        StartSpinner()
        getDataAboutRequestAndPopulateIt(request: requestID)
        CountDownIconWidth.constant = 62
        navigationIconWidth.constant = 0
        ViewWithProfileImgWidth.constant = 0
        ViewWithUsernameAndPicWidth.constant = 128
        
        imgProfilePicOnButton.layer.cornerRadius = imgProfilePicOnButton.frame.size.width / 2
        imgProfilePicOnButton.layer.masksToBounds = true
        
        timer1.invalidate()
        StopSpinner()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "cancelled"), object: nil)

    }
    
    @objc func TripCanceled(note:Notification){
        let alert2 = UIAlertController(title: "oops", message: "The Trip was cancelled by user", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            Defaults[.CurrentTripIDKey] = 0
            self.navigationController?.popViewController(animated: true)
        }
        
        alert2.addAction(OkAction)
        present(alert2, animated: true) {
            // goahed and remove trip related dat
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.StartCountDown()
    }
    
    
    
    func getDataAboutRequestAndPopulateIt(request:Int){
        StartSpinner()
        print(requestID)
        let parmm = [
            "request_id":requestID,
            ]
        let token = Defaults[.deviceTokenKey]
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        
        Alamofire.request(WebServiceClass().BaseURL + "driver/view/request", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSONDecodable{ (response:DataResponse<RequestDetailsResponse>) in
            switch response.result{
            case .success(let resp):
                requestDetailsResponse = resp
                print("received response from requestid  : \(resp)")
                
            
                
                self.updateUiUsingData(data: resp)
                
                if(self.firstupdate == 0)
                {
                  //  self.firstupdate = 1
                self.timer1 = Timer.scheduledTimer(timeInterval: 10, target: self, selector:#selector(self.updatepath), userInfo: nil, repeats: true)
                }
                else
                {
                    self.timer1.invalidate()

                }
            case .failure(let err):
                print(err)
                StopSpinner()
                
            }
        }
    }
    
    
 var tolat = Double()
    var tolng = Double()
    
    var fromlat = Double()
    var fromlong = Double()
    
    @objc func updatepath()
    {
//        self.drawPath(originLat: locationManager.location!.coordinate.latitude, originLong: locationManager.location!.coordinate.longitude, destLat: (requestDetailsResponse?.data.body.fromLat)!, destLong: (requestDetailsResponse?.data.body.fromLng)!)
        
    }
    @objc func updatepath1()
    {
//        self.drawPath(originLat: locationManager.location!.coordinate.latitude, originLong: locationManager.location!.coordinate.longitude, destLat: tolat, destLong:tolng)
        
    }
    
    

    func updateUiUsingData(data:RequestDetailsResponse){
        
        estimatedAmmount = data.data.body.totalEstimatedTripCost
        userprofileImageString = data.data.body.user.profilePic!
        nameOfUser = data.data.body.user.name
        userMobileNumber = data.data.body.user.contactNumber
        lblAddress.text = data.data.body.fromAddress
        currentAddressText = data.data.body.toAddress
     
        lblRating.text = data.data.average_user_rating
        print(data.data.average_user_rating)
        tolat = data.data.body.toLat
        tolng = data.data.body.toLng

        lblETA.text = "\(data.data.body.totalEstimatedTravelTime)  Away"
        lblNameOfUser.text = data.data.body.user.name
        //TODO: Rating is not availible in response
        lblCarName.text = "\(data.data.vehicleYear)" + " " + data.data.vehicelName +  " " + "\(data.data.vehicelModel)" +  " " + data.data.vehicleColor
        //set profile img
        print(data.data.body.user.profilePic!)
        let imgUrlResource = ImageResource(downloadURL: URL(string: data.data.body.user.profilePic!)!)
        imgProfilePic.kf.setImage(with: imgUrlResource, placeholder: UIImage(named:"default-user"), options: nil, progressBlock: nil) { (img, err, cache, url) in
            print(err)
        }
      //  imgProfilePicOnButton.kf.setImage(with: imgUrlResource)
        
        imgProfilePicOnButton.kf.setImage(with: imgUrlResource, placeholder: UIImage(named: "default-user"), options: nil, progressBlock: nil)

        
        self.fromlat = data.data.body.fromLat
        self.fromlong = data.data.body.fromLng

        self.destCord = CLLocationCoordinate2D(latitude: data.data.body.toLat, longitude: data.data.body.toLng)
        
        self.drawPath(originLat: locationManager.location!.coordinate.latitude, originLong: locationManager.location!.coordinate.longitude, destLat: data.data.body.fromLat, destLong: data.data.body.fromLng)
        if(Defaults[.SelectedNavigationAppKey] ==  0)
        {
            googleUrl = URL(string: "comgooglemaps://?saddr=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.longitude)&daddr=\(data.data.body.fromLat),\(data.data.body.fromLng)&directionsmode=driving")
        }
        else if(Defaults[.SelectedNavigationAppKey] ==  1)
        {
              googleUrl = URL(string: "https://waze.com/ul?ll=\(data.data.body.fromLat),\(data.data.body.fromLng)&navigate=yes")
       

            
        }
        else
        {
           googleUrl = URL(string:"http://maps.apple.com/?saddr=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.longitude)&daddr=\(data.data.body.fromLat),\(data.data.body.fromLng)")!
            
        }

     //   googleUrl = URL(string: "comgooglemaps://?saddr=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.longitude)&daddr=\(data.data.body.fromLat),\(data.data.body.fromLng)&directionsmode=driving")
        StopSpinner()
        
    }
    
    
    func drawPath(originLat:Double,originLong:Double,destLat:Double,destLong:Double)
    {
       // StartSpinner()
        
        
        let originCoord = CLLocationCoordinate2D(latitude: originLat, longitude: originLong)
        let destCoord = CLLocationCoordinate2D(latitude: destLat, longitude: destLong)
        
        
        let origin = "\(originLat),\(originLong)"
        let destination = "\(destLat),\(destLong)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDuLTaJL-tMzdBoTZtCQfCz4m66iEZ1eQc"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue
//            let boundnorthlat = json["routes"].arrayValue[0]["bounds"]["northeast"]["lat"].doubleValue
//            let boundnorthlong = json["routes"].arrayValue[0]["bounds"]["northeast"]["long"].doubleValue
//
//            let boundsouthlat = json["routes"].arrayValue[0]["bounds"]["southwest"]["lat"].doubleValue
//            let boundsouthlong = json["routes"].arrayValue[0]["bounds"]["southwest"]["long"].doubleValue

         
          
            //fit two points on map
            
             self.mapView.clear()
            var bounds = GMSCoordinateBounds()
            
            bounds = bounds.includingCoordinate(originCoord)
            bounds = bounds.includingCoordinate(destCoord)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
            self.mapView.animate(with: update)
            
            let destMarker = GMSMarker()
            let sourceMarker = GMSMarker()
            sourceMarker.position = self.sourceCord
            destMarker.position = destCoord
            sourceMarker.icon = #imageLiteral(resourceName: "Start-pin")
            destMarker.icon = #imageLiteral(resourceName: "Start-pin.png")
            destMarker.map = self.mapView
            sourceMarker.map = self.mapView
           
        
            for route in routes
            {
                let legs = route["legs"]
                
                let firstLeg = legs[0]
                let firstLegDurationDict = firstLeg["duration"]
                let firstLegDuration = firstLegDurationDict["text"]
                self.lblETA.text = String(describing: firstLegDuration) + " away"
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeColor = UIColor.black
                polyline.strokeWidth = 5
                polyline.map = self.mapView
            }
            
           // StopSpinner()
        }
    }
    //Basic Setup
    func setupUI(){

        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json")
            {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        
        // for Location Manager Request
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.isMyLocationEnabled = true
        
        //fix some ui
        btnCallUser.layer.cornerRadius = btnCallUser.frame.height/2
        btnCallUser.layer.masksToBounds = true
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height/2
        imgProfilePic.layer.masksToBounds = true
        
        
        //Hide Nav Icon
        navigationIconWidth.constant = 0
    }
    
    
    //MARK:- Timer
    func StartCountDown(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    @objc func updateTimer(){
        seconds -= 1
        
        if seconds == 0{
            self.lblCountDown.isHidden = true
            timer.invalidate()
            self.navigationController?.popViewController(animated: true)
        }
        else if seconds > 60 {
            self.lblCountDown.text = "\(seconds / 60):\(seconds % 60)"
            
        }else {
            self.lblCountDown.text = "\(seconds)"

        }
        
        
    }
    
//    counter to draw path
    func StartpathCounter(every:Double){
//        self.timer = Timer.scheduledTimer(timeInterval: every, target: self, selector: #selector(updatePath), userInfo: nil, repeats: true)

    }
   
    
    //MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.sourceCord = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)

      if let res = requestDetailsResponse
      {
        
        if(firstupdate == 0)
        {
          self.drawPath(originLat: self.sourceCord.latitude, originLong: self.sourceCord.longitude, destLat: fromlat, destLong:fromlong)
        }
        else
        {
            if(tolat != nil)
            {
            drawPath(originLat:self.sourceCord.latitude, originLong: self.sourceCord.longitude, destLat: tolat, destLong: tolng)

            }
        }
        }
        
        
//        DispatchQueue.main.async {
////                        self.drawPath()
//        }
////        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting the location \(error.localizedDescription)")
    }
    //move cammera to center
    func moveMapCameratoCurrent(coord:CLLocationCoordinate2D){
        let center = CLLocationCoordinate2D(latitude: coord.latitude , longitude: coord.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: coord.latitude, longitude: coord.longitude, zoom: 15);
        self.mapView.camera = camera
    }
    
    
    
    //MARK: Delegate Methods
    
    
    func confromaction() {
        
        
        self.view.bringSubview(toFront: btnCallUser)
        btnTapToBeDriver.setTitle("Start", for: .normal)
        
        btnCallUser.isHidden = false
        StopSpinner()
    }
    
    //timer trigers this func
//    @objc func updatePath(){
//        if (btnTapToBeDriver.titleLabel?.text?.starts(with: "Tap"))!{
//
//
//
//        }
//        else if (btnTapToBeDriver.titleLabel?.text?.starts(with: "Arr"))!{
//
//
//
//
//        }
//        else if (btnTapToBeDriver.titleLabel?.text?.starts(with: "Start"))!{
//
//
//        }
//        else if (btnTapToBeDriver.titleLabel?.text?.starts(with: "Drop"))!{
//
//        }
//    }
    
    //MARK:- Button Actions
    
    
    @IBAction func TapToBeaDriver(_ sender: UIButton) {
        if (sender.titleLabel?.text?.starts(with: "Tap"))!{
            timer.invalidate()
            AcceptBeADriverRequest()
        
        }
        else if (sender.titleLabel?.text?.starts(with: "Arr"))!{
            
            let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpConfirmArrival") as! popUpConfirmArrival
            
            self.addChildViewController(popOverConfirmVC)
            popOverConfirmVC.view.frame = self.view.frame
            popOverConfirmVC.delegate = self
            popOverConfirmVC.address = self.lblAddress.text!
            popOverConfirmVC.personImageString = self.userprofileImageString
            
            self.view.center = popOverConfirmVC.view.center
            self.view.addSubview(popOverConfirmVC.view)
            popOverConfirmVC.didMove(toParentViewController: self)
            
            
        }
        else if (sender.titleLabel?.text?.starts(with: "Start"))!{
            tripStartTime = Date()
            let popUpNavigateVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpNavigate") as! popUpNavigate
            self.addChildViewController(popUpNavigateVC)
            
              self.firstupdate = 1
            if(Defaults[.SelectedNavigationAppKey] ==  0)
            {
            googleUrl = URL(string: "comgooglemaps://?saddr=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.longitude)&daddr=\(tolat),\(tolng)&directionsmode=driving")
            }
            else if(Defaults[.SelectedNavigationAppKey] ==  1)
            {
                 googleUrl = URL(string: "https://waze.com/ul?ll=\(tolat),\(tolng)&navigate=yes")
               
            }
            else
            
            {
         googleUrl = URL(string:"http://maps.apple.com/?saddr=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.longitude)&daddr=\(tolat),\(tolng)")!
            }
           
           
        
            self.timer1.invalidate()
            self.timer2 = Timer.scheduledTimer(timeInterval: 10, target: self, selector:#selector(self.updatepath1), userInfo: nil, repeats: true)



            drawPath(originLat: (locationManager.location?.coordinate.latitude)!, originLong: (locationManager.location?.coordinate.longitude)!, destLat: tolat, destLong: tolng)
            popUpNavigateVC.view.frame = self.view.frame
            popUpNavigateVC.delegate = self
            
            popUpNavigateVC.addressText = currentAddressText
            popUpNavigateVC.nameOfUser = nameOfUser
            popUpNavigateVC.imageUrlString = userprofileImageString
            popUpNavigateVC.destCoord = destCord
            
            self.view.center = popUpNavigateVC.view.center
            self.view.addSubview(popUpNavigateVC.view)
            popUpNavigateVC.didMove(toParentViewController: self)
            
            
        }
        else if (sender.titleLabel?.text?.starts(with: "Drop"))!{
            // show pop confirmDropOff
            // call get callback on confirm
            //make call to update status
            
            //show pop
            timer2.invalidate()
            let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpConfirmDropOff") as! PopUpConfirmDropOff
            self.addChildViewController(popOverConfirmVC)
            popOverConfirmVC.view.frame = self.view.frame
            popOverConfirmVC.delegate = self
            popOverConfirmVC.imgString = userprofileImageString
            popOverConfirmVC.nameOfuser = nameOfUser
            self.view.center = popOverConfirmVC.view.center
            self.view.addSubview(popOverConfirmVC.view)
            popOverConfirmVC.didMove(toParentViewController: self)
            //
        }
        
        
    }
    
    
    func tappedCallBtn() {
        //tapped call button on the popup
        print("tapped call button on the popup")
        if let url = URL(string: "tel://\(userMobileNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            print("Your device doesn't support Calling feature.")
            let alert = AlertBuilder(title: "oops", message: "Yourdevice does not have call feature")
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func tappedNavigate(str: String) {
        print(str)
        
        changeTripStatus(status: Defaults[.CurrentTripStatusKey] + 2)
        
        
        
    }
    
    func tappedOnConfirmDropOff(str: String) {
        print(str)
        tripEndTime = Date()
        tripTimeInterval = (tripEndTime?.timeIntervalSince(tripStartTime!))!
        
        
        getGetDistancebtwnCordinates(Sourcecoord: sourceCord, destCoord: destCord) { (duration,distance) in
            self.totalTripDistance = distance
            self.getStateNamefromCoord(coord: self.sourceCord) { (stateName) in
                self.getRateswithState(state: stateName, completion: { (rateResponse) in
                    
                    self.stateRates = rateResponse
                    print("StateRates : \(self.stateRates)")
                    self.changeTripStatus(status: Defaults[.CurrentTripStatusKey] + 3)
                    
                })
                
                print(stateName)
            }
            
            
        }
        //call user/get/rates with state parameter
        
        //        getAddressfromCoord(coord: sourceCord) { (stateName) in
        //            print(stateName)
        //           self.getRateswithState(state: stateName)
        //        }
    }
    
    
    func ConfirmArrival(str: String) {
        print(str)
        //        Defaults[.CurrentTripIDKey] = resp.data.id
        //        Defaults[.CurrentTripStatusKey] = resp.data.status
        print("Current trip id and staus = \(Defaults[.CurrentTripIDKey])   \( Defaults[.CurrentTripStatusKey])")
        
        
        changeTripStatus(status: Defaults[.CurrentTripStatusKey] + 1)
        
    }
    
    
    
    func ChangeLayoutToDropOff(){
        //new button set visible
        
        imgProfilePicOnButton.isHidden = false
        btnCallUser.isHidden = true
        btnTapToBeDriver.setTitle("Drop Off \(lblNameOfUser.text!)", for: .normal)
        ViewWithProfileImgWidth.constant = viewWithProfImgWidthConstant
        ViewWithUsernameAndPicWidth.constant = 0
        lblAddress.text = currentAddressText
        timer.invalidate()
        navigationIconWidth.constant = 62
        CountDownIconWidth.constant = 0
        ViewWithUsernameAndPic.isHidden = true
        
        
    }
    
    @IBAction func tappedOnimgBesidesButton(_ sender: UITapGestureRecognizer) {
        TapToBeaDriver(btnTapToBeDriver)
    }
    
    
    
    func changeTripStatus(status:Int){
        StartSpinner()
        
        
        
        var parmm :Parameters = [:]
        
        if status == 4 {
            actualTripPrice = Double(stateRates!.data.baseFee!) + (tripTimeInterval! / 60) * (stateRates?.data.timeFee)! + Double(totalTripDistance!) * Double(stateRates!.data.mileFee!)
            print("Total Time Interval \(tripTimeInterval)")
            parmm = [
                "trip_id": Defaults[.CurrentTripIDKey],
                "status": status,
//                "actual_trip_travel_time":tripTimeInterval! / 60,
                "actual_trip_amount":actualTripPrice,
                "actual_trip_miles":totalTripDistance!,
            ]
        }else{
            
            parmm = [
                "trip_id": Defaults[.CurrentTripIDKey],
                "status": status
            ]
        }
        
        
        let token = Defaults[.deviceTokenKey]
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        
        Alamofire.request(WebServiceClass().BaseURL + "driver/trip/change/status", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            switch response.result{
            case .success(let resp):
                print("received response from changestatus  : \(resp)")
                print(resp)
                //change layout to Start Trip
                if status == 2{
                    self.ChangeLayoutToStartTrip()
                    StopSpinner()
                    
                    
                }else if status == 3{
                    self.ChangeLayoutToDropOff()
                    StopSpinner()
                    
                    
                }else if status == 4{
                    
                    
                    guard let myTripResponse : TripStatusResponse = try? JSONDecoder().decode(TripStatusResponse.self, from: response.data!) else {
                        print("could not get parse MyTrip Response")
                        StopSpinner()
                        
                        return
                    }
                    
                    //TODO:uncoment it
                    self.performSegue(withIdentifier: "ToDriverRatingVirew", sender: myTripResponse)
                   // print(myTripResponse)
                    StopSpinner()
                    
                }
                
                
            case .failure(let err):
                print(err.localizedDescription)
                if status == 2{
                    print("Could not change status to 2")
                    StopSpinner()
                    
                    
                }else if status == 3{
                    print("Could not change status to 3")
                    StopSpinner()
                    
                    
                }else if status == 4{
                    print("Could not change status to 4")
                    StopSpinner()
                    
                    
                }
            }
        }
    }
    
    
    
    
    func getStateNamefromCoord(coord:CLLocationCoordinate2D, completion:@escaping (String)->Void){
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coord) { response , error in
            
            
            if error == nil{
                if let address = response!.firstResult() {
                    
                    
                    print(address.administrativeArea ?? address.locality!)
                    
                    //
                    completion(address.administrativeArea ?? address.locality!)
                    
                }
                
            }else{
                print("Can not fetch  StateName from Coordinates")
            }
        }
        
    }
    
    func getRateswithState(state:String,completion:@escaping (StateRateResponse)->Void) -> Double {
        StartSpinner()
        
        let parmm = [
            "state": state
        ]
        
        let token = Defaults[.deviceTokenKey]
        let headers = ["Accept": "application/json","Authorization": "Bearer " + token]
        
        Alamofire.request(WebServiceClass().BaseURL + "get/rates", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSONDecodable { (dataresponse:DataResponse<StateRateResponse>) in
            switch dataresponse.result{
            case .success(let resp):
                StopSpinner()
                print("response from get state rate")
                print(resp)
                completion(resp)
            case .failure(let err):
                StopSpinner()
                print(err.localizedDescription)
                print("Could not  get Rates from state")
                let alert = AlertBuilder(title: "oops", message: "Could Not get rates from state")
            }
        }
        
        StopSpinner()
        
        return 0.0
    }
    
    
    
    func ChangeLayoutToStartTrip(){
        //change button to Start
        btnTapToBeDriver.setTitle("Start", for: .normal)
        btnCallUser.isHidden = false
        navigationIconWidth.constant = 0
        CountDownIconWidth.constant = 62
        
        seconds = 300
        StartCountDown()
        timershouldStop = true
        
        imgViewPin.isHidden = true
        lblETA.isHidden = true
        //currentAddressText = lblAddress.text!
        lblAddress.text = "Prepare To Drive User's Car"
        
        //clear map
        //draw path from my loc to dest
        mapView.clear()
        
        drawPath(originLat: locationManager.location!.coordinate.latitude, originLong: locationManager.location!.coordinate.longitude, destLat: sourceCord.latitude, destLong: sourceCord.longitude)
        
        
    }
    
    
    
    
    //prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
            if segue.identifier == "ToDriverRatingVirew"{
            let dest = segue.destination as! DriverRatingVC
            dest.dropOffRespose = sender as! TripStatusResponse
                dest.tripAmmount = actualTripPrice
            dest.profilepicString = userprofileImageString
        }
    }
    func yesAction(_ bool: Bool) {
        Defaults[.CurrentTripIDKey] = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    func NoAction(_ bool: Bool) {
        
    }
    
    //Make network call to accept request
    func AcceptBeADriverRequest(){
        StartSpinner()
        if requestID == 0 {
            let alert = AlertBuilder(title: "oops", message: "Please accept driver request")
            
        }
        else{
            
            let parmm = [
                "request_id":requestID,
                ]
            let token = Defaults[.deviceTokenKey]
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            Alamofire.request(WebServiceClass().BaseURL + "driver/accept/request", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSONDecodable{ (response:DataResponse<BeAdriverResponse>) in
                switch response.result{
                case .success(let resp):
                    print("resp")
                    if(resp.errorCode == 0)
                    {
                        
                        print("received response from tapTobeAdriver  : \(resp)")
                        StopSpinner()
                        self.timer.invalidate()
                        
                        Defaults[.CardTokenKey] = resp.data!.cardToken
                        Defaults[.CurrentTripIDKey] = resp.data!.id
                        Defaults[.CurrentTripStatusKey] = resp.data!.status
                        
                        self.ConvertVCTOArriveForJoy()
                    }
                    else
                    {
                        StopSpinner()
                        let popOverCallVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpNoUser") as! popUpNoUser
                        self.addChildViewController(popOverCallVC)
                        popOverCallVC.view.frame = self.view.frame
                        self.view.center = popOverCallVC.view.center
                        self.view.addSubview(popOverCallVC.view)
                        popOverCallVC.didMove(toParentViewController: self)
                        
                    }
                    
                case .failure(let err):
                    print(err)
                    
                    StopSpinner()
                    let popOverCallVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpNoUser") as! popUpNoUser
                    popOverCallVC.delegate = self
                    self.addChildViewController(popOverCallVC)
                    popOverCallVC.view.frame = self.view.frame
                    self.view.center = popOverCallVC.view.center
                    self.view.addSubview(popOverCallVC.view)
                    popOverCallVC.didMove(toParentViewController: self)
                    
                    
                    
//                    StopSpinner()
//                    // pop and say something happened
//                    let alert2 = UIAlertController(title: "oops", message: "This user is already taken by other driver.", preferredStyle: .alert)
//                    let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
//                        // goahed and remove trip related dat
//
//                        Defaults[.CurrentTripIDKey] = 0
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    alert2.addAction(OkAction)
//                    self.present(alert2, animated: true) {
//
//                    }
                    
                }
            }
        }
        
    }
    
    func ConvertVCTOArriveForJoy(){
        //change name of button
        //hide counter show nav
        //remove Timer
        
        btnTapToBeDriver.setTitle("Arrive for \(nameOfUser)", for: .normal)
        navigationIconWidth.constant = 56
        CountDownIconWidth.constant = 0
        timershouldStop = true
        StopSpinner()
        
    }
    
    
    //    @IBAction func ConfromArrival(_ sender: Any) {
    //
    //        print(btnTapToBeDriver.titleLabel?.text!)
    //        if(btnTapToBeDriver.titleLabel?.text == "Start")
    //        {
    //            let popUpDropOffvc = self.storyboard?.instantiateViewController(withIdentifier: "popUpDropOff") as! popUpDropOff
    //            self.addChildViewController(popUpDropOffvc)
    //            popUpDropOffvc.view.frame = self.view.frame
    //            self.view.center  = popUpDropOffvc.view.center
    //            self.view.addSubview(popUpDropOffvc.view)
    //            popUpDropOffvc.didMove(toParentViewController: self)
    //
    //        }
    //        else
    //        {
    //
    //
    //            let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpConfirmArrival") as! popUpConfirmArrival
    //            self.addChildViewController(popOverConfirmVC)
    //            popOverConfirmVC.view.frame = self.view.frame
    //            self.view.center = popOverConfirmVC.view.center
    //            self.view.addSubview(popOverConfirmVC.view)
    //            popOverConfirmVC.didMove(toParentViewController: self)
    //        }
    //    }
    
    
    
    
    @IBAction func btnPhoneCall(_ sender: Any) {
        let popOverCallVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpPhoneCall") as! popUpPhoneCall
        popOverCallVC.delegate = self
        popOverCallVC.nameToshow = nameOfUser
        self.addChildViewController(popOverCallVC)
        popOverCallVC.view.frame = self.view.frame
        self.view.center = popOverCallVC.view.center
        self.view.addSubview(popOverCallVC.view)
        popOverCallVC.didMove(toParentViewController: self)
        
        
        
        
        //        if let url = URL(string: "tel://\("9898898988989")"), UIApplication.shared.canOpenURL(url) {
        //            if #available(iOS 10, *) {
        //                UIApplication.shared.open(url)
        //            } else {
        //                UIApplication.shared.openURL(url)
        //            }
        //        }
        //        else {
        //            print("Your device doesn't support this feature.")
        //        }
    }
    
    
    var googleUrl = URL(string: "")
  var wazeURL = URL(string: "")
    @IBAction func btnNavigateExternal(_ sender: UIButton) {
        //TODO: Check Setting for default navigaion app
//        var sourceLocation = CLLocationCoordinate2D()
//        var destinationLocation = CLLocationCoordinate2D()
//
        
        
        if btnTapToBeDriver.titleLabel!.text! == "Arr"
        {
            
          //    googleUrl = URL(string: "comgooglemaps://?saddr=\(locationManager.location!.coordinate.latitude),\(locationManager.location?.coordinate.longitude)&daddr=\(self.sourceCord.latitude),\(self.sourceCord.longitude)&directionsmode=driving")
            
        }else {
           // googleUrl = URL(string: "comgooglemaps://?saddr=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.longitude)&daddr=\(self.destCord.latitude),\(self.destCord.longitude)&directionsmode=driving")
        }
        
        
//        {
//                //navigate from current to client
//            sourceLocation =  (locationManager.location?.coordinate)!
//                destinationLocation = stripAmmountelf.sourceCord
//        }
//        else if btnTapToBeDriver.titleLabel!.text! == "Drop" {
////            navigate from current to dest
//            sourceLocation =  locationManager.location!.coordinate
//        }
        
        
        
        
        if Defaults[.SelectedNavigationAppKey] == 0{
            
            
            
            if Defaults[.isGoogleMapsInstalled] == true{
                // go navigate
                
                
//                let GoogleUrl = URL(string: "comgooglemaps://?saddr=\(sourceCord.latitude),\(sourceCord.longitude)&daddr=\(self.destCord.latitude),\(self.destCord.longitude)&directionsmode=driving")
                
                    
                UIApplication.shared.open(googleUrl!, options: [:]) { (booll) in
                    if booll{
                        print("opening External Navigaion app")
                    }else{
                        print("Could Not open Navigation app")
                    }
                }
            }else{
                // ask user to install the app
                let alert = AlertBuilder(title: "oops", message: "google Maps is not installed")
                self.present(alert, animated: true, completion: nil)
            }
        }
        else if Defaults[.SelectedNavigationAppKey] == 1{
            if Defaults[.iswazeInstalled] == true{
                // go navigate
             //   let wazeURL = URL(string: "https://waze.com/ul?ll=\(self.destCord.latitude),\(self.destCord.longitude)&navigate=yes")
                UIApplication.shared.open(googleUrl!, options: [:]) { (booll) in
                    if booll{
                        print("opening External Navigaion app")
                    }else{
                        print("Could Not open Navigation app")
                    }
                }
            }else{
                // ask user to install the app
                let alert = AlertBuilder(title: "oops", message: "Waze Maps is not installed")
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            UIApplication.shared.open(googleUrl!, options: [:]) { (booll) in
                if booll{
                    print("opening External Navigaion app")
                }else{
                    print("Could Not open Navigation app")
                }
            }
        
            
        }
       
        
    }
}
