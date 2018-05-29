//
//  locationHelper.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 11/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
import GoogleMaps
import SwiftLocation
import Alamofire
import SwiftyJSON

func getGetDistancebtwnCordinates(Sourcecoord:CLLocationCoordinate2D,destCoord:CLLocationCoordinate2D,completion:@escaping (Double,Double)->Void){
StartSpinner()
    let origin = "\(Sourcecoord.latitude),\(Sourcecoord.longitude)"
    let destination = "\(destCoord.latitude),\(destCoord.longitude)"
    let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDuLTaJL-tMzdBoTZtCQfCz4m66iEZ1eQc"
    
    Alamofire.request(url).responseJSON { response in
        print(response.request ?? "")  // original URL request
        print(response.response ?? "") // HTTP URL response
        print(response.data ?? "")     // server data
        print(response.result)   // result of response serialization
        do {
            StopSpinner()
            let json = try JSON(data: response.data!)
            
            let routes = json["routes"].arrayValue
            
            for route in routes
            {
                
                
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 6.0
                polyline.strokeColor = UIColor.black
                
                
                
                let legs = route["legs"]
                
                let firstLeg = legs[0]
                let firstLegDurationDict = firstLeg["duration"]
                let firstLegDuration = firstLegDurationDict["text"]
                let strDuration = firstLegDuration.doubleValue
                
                let firstLegDistanceDict = firstLeg["distance"]
                let firstLegDistance = firstLegDistanceDict["text"]
                let strDistance = firstLegDistance.doubleValue
                completion(strDuration,strDistance)
                
                var bounds = GMSCoordinateBounds()
                                
                let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
                
                
                
                
             
                
                
             
                
            }
        }
        catch _ {
StopSpinner()
            // Error handling
        }
        
        //            if (PFUser.currentUser() != nil) {
        //                return true
        //            }
    }
}
