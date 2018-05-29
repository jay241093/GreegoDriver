//
//  NavigateVC.swift
//  Greegodriverapp
//
//  Created by Ravi Dubey on 4/23/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class NavigateVC: UIViewController ,CLLocationManagerDelegate,GMSMapViewDelegate{

    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
setupUI()
        // Do any additional setup after loading the view.
    }
    var locationManager = CLLocationManager()
    var centerMapCoordinate:CLLocationCoordinate2D!
    var sourceCord = CLLocationCoordinate2D()
    var destCord : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees("23.037431")!, longitude: CLLocationDegrees("72.6298913")!)
    var sourceMarker = GMSMarker()
    var destMarker = GMSMarker()

    
    
    
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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
    self.mapView.isMyLocationEnabled = true
    }
        //MARK: CLLocation Manager Delegate
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last
            self.sourceCord = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
            let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 18.0)
            
            var marker = GMSMarker()
           
            
            self.mapView?.animate(to: camera)
            
            
            
            
            DispatchQueue.main.async {
                self.drawPath()
            }
            locationManager.stopUpdatingLocation()
        }
        
        
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error while getting the location \(error.localizedDescription)")
        }

        
        
        func drawPath()
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
                        polyline.map = self.mapView
                        
                        
                        let legs = route["legs"]
                        var strDuration = String()
                        
                        let firstLeg = legs[0]
                        let firstLegDurationDict = firstLeg["duration"]
                        print(firstLegDurationDict)
                        
                        let firstLegDuration = firstLegDurationDict["text"]
                       
                       
                        //   let sourceText = sourceDic!["text"] as! NSString
                        
                        let arrayOfMarkers = [self.sourceMarker,self.destMarker]
                        var bounds = GMSCoordinateBounds()
                        
                        bounds = bounds.includingCoordinate(self.sourceCord)
                        bounds = bounds.includingCoordinate(self.destCord)
                        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
                        self.mapView.animate(with: update)
                        
                        self.sourceMarker.icon = #imageLiteral(resourceName: "Ellipse 2")
                        self.sourceMarker.position = CLLocationCoordinate2D(latitude: (self.sourceCord.latitude), longitude: (self.sourceCord.longitude))
                        self.sourceMarker.map = self.mapView
                        
                        
                        self.destMarker.icon = #imageLiteral(resourceName: "Start-pin")
                        self.destMarker.position = CLLocationCoordinate2D(latitude: self.destCord.latitude, longitude: self.destCord.longitude)
                        self.destMarker.map = self.mapView
                        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -IBAction
    
    
    @IBAction func Dropoffjay(_ sender: Any) {
        let popUpDropOffvc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpConfirmDropOff") as! PopUpConfirmDropOff
        self.addChildViewController(popUpDropOffvc)
        popUpDropOffvc.view.frame = self.view.frame
        self.view.center  = popUpDropOffvc.view.center
        self.view.addSubview(popUpDropOffvc.view)
        popUpDropOffvc.didMove(toParentViewController: self)
        
        
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
