//
//  RidehistoryVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/19/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import MapKit

class RidehistoryVC: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var lblfinltotal: UILabel!
    @IBOutlet weak var lbltotal: UILabel!
    @IBOutlet weak var lbldistance: UILabel!
    @IBOutlet weak var lblgreegofees: UILabel!
    
    @IBOutlet weak var lblreciptno: UILabel!
    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var lblstart1: UILabel!
    
    @IBOutlet weak var lblend1: UILabel!
    
   var greegofees = Double()
    var driverdic : NSDictionary = NSDictionary()
    let sourceMarker = GMSMarker()
    let destMarker = GMSMarker()

    var locationmanager = CLLocationManager()
    @IBOutlet weak var lblreq: UILabel!
    
    @IBOutlet weak var lblstart: UILabel!
    
    @IBOutlet weak var lblend: UILabel!
    
    @IBOutlet weak var lbldate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
       var distance = driverdic.value(forKey:"actual_trip_miles") as? Double
        var time = driverdic.value(forKey:"total_estimated_travel_time") as? String
        var transaction_id = driverdic.value(forKey:"transaction_id") as? String


        if let id = transaction_id
        {
        lblreciptno.text = "Recipt No # : (" + transaction_id! + ")"
        }
        else
        {
            lblreciptno.text = "Recipt No # : ()"

        }
        lbldistance.text =  String(format: "%.2f",distance!) + " miles ," + time! + "min"
        
        
        StartLocationUpdateInDevice()
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json")
            {
                mapview.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor(red:0.00, green:0.58, blue:0.59, alpha:1.0)]
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString1 = NSMutableAttributedString(string:"S", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"tart", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(string:"E", attributes:attrs1)
        let attributedString4 = NSMutableAttributedString(string:"nd", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        attributedString3.append(attributedString4)
        
        self.lblstart.attributedText = attributedString1
        self.lblend.attributedText = attributedString3
      
        
        
        
       lbldate.text = driverdic.value(forKey: "created_at")  as! String
        lblstart.text = driverdic.value(forKey: "start_time")  as! String
        lblend.text = driverdic.value(forKey: "end_time")  as! String

        let sourcelat = driverdic.value(forKey: "from_lat") as! NSNumber
        let sourcelng = driverdic.value(forKey: "from_lng") as! NSNumber
        
        let deslat = driverdic.value(forKey: "to_lat") as! NSNumber
        let deslng = driverdic.value(forKey: "to_lng") as! NSNumber
        var source = CLLocationCoordinate2D(latitude: sourcelat.doubleValue, longitude: sourcelng.doubleValue)
        var destination = CLLocationCoordinate2D(latitude:deslat.doubleValue, longitude: deslng.doubleValue)
      
      lblreq.text = driverdic.value(forKey: "created_at")  as! String
        
        self.drawPath(sourceCord: source, destCord: destination)
        
        let amoount = driverdic.value(forKey:"total_estimated_trip_cost") as? Double
        
        if let id = amoount
        {
        lbltotal.text =  "$ " +  String(format: "%.2f",amoount!)
        }
        else
        {
            
            lbltotal.text =  "$ 0"

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - IBaction methods

    
    @IBAction func back(_ sender: Any) {
        
        
        navigationController?.popToRootViewController(animated: true)

        
        
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
                let amoount = self.driverdic.value(forKey:"total_estimated_trip_cost") as? Double
                
               if(amoount != nil)
               {
                var greegofee =  (amoount! * rateResponse.data.greegoFee!) / 100
                
                self.lblgreegofees.text = "- $ " + String(format: "%.2f",greegofee)
                var cost = self.driverdic.value(forKey:"total_estimated_trip_cost") as! Double
                
           var total =  cost - greegofee
                
            self.lblfinltotal.text =  "$ " + String(format: "%.2f",total)
                }
            })
            
            print(stateName)
        }
        locationmanager.stopUpdatingLocation()
    }
    
    
    
    
    
    
    //MARK: - USER DEFINE FUNCTIONS
    
    
    func drawPath(sourceCord:CLLocationCoordinate2D,destCord:CLLocationCoordinate2D)
    {
        let origin = "\(sourceCord.latitude),\(sourceCord.longitude)"
        let destination = "\(destCord.latitude),\(destCord.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDuLTaJL-tMzdBoTZtCQfCz4m66iEZ1eQc"
        
        Alamofire.request(url).responseJSON { response in
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // HTTP URL response
            print(response.data ?? "")     // server data
            print(response.result)   // result of response serialization
            do {
                print(response.data!)
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 3.0
                    polyline.strokeColor = UIColor.black
                    polyline.map = self.mapview
                    
                    
                    let legs = route["legs"]
                    var strDuration = String()
                    
                    let firstLeg = legs[0]
                    let firstLegDurationDict = firstLeg["duration"]
                    print(firstLegDurationDict)
                    
                    let firstLegDuration = firstLegDurationDict["text"]
                    
                    
                    //   let sourceText = sourceDic!["text"] as! NSString
                    
                    let arrayOfMarkers = [self.sourceMarker,self.destMarker]
                    var bounds = GMSCoordinateBounds()
                    
                    bounds = bounds.includingCoordinate(sourceCord)
                    bounds = bounds.includingCoordinate(destCord)
                    let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
                    self.mapview.animate(with: update)
                    
                    self.sourceMarker.icon = #imageLiteral(resourceName: "Ellipse 2")
                    self.sourceMarker.position = CLLocationCoordinate2D(latitude: (sourceCord.latitude), longitude: (sourceCord.longitude))
                    self.sourceMarker.map = self.mapview
                    
                    
                    self.destMarker.icon = #imageLiteral(resourceName: "Start-pin")
                    self.destMarker.position = CLLocationCoordinate2D(latitude:destCord.latitude, longitude:destCord.longitude)
                    self.destMarker.map = self.mapview
                    
                }
            }
            catch _ {
                // Error handling
            }
            
            //            if (PFUser.currentUser() != nil) {
            //                return true
            //            }
        }
    }
        
        
        
        
        
        
 
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        polyline.map = self.mapview // Your map view
        mapview.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: path!), withPadding: 10))

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
