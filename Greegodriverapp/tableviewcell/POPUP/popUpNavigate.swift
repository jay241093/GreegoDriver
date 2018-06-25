//
//  popUpDropOff.swift
//  PopUp
//
//  Created by Vipul on 19/04/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit
import GoogleMaps
import Kingfisher
protocol  popUpNavigateProtocol {
    
    func tappedNavigate(str:String)
}

class popUpNavigate: UIViewController {
    
    
    @IBOutlet weak var imgViewUserProfilepic: UIImageView!
    @IBOutlet weak var lblDropOffUser: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    
    var delegate : popUpNavigateProtocol?
    
    var nameOfUser = ""
    var imageUrlString = ""
    var addressText = ""
    var destCoord = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    //    var map
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        imgViewUserProfilepic.layer.cornerRadius = imgViewUserProfilepic.frame.size.width / 2
        
        imgViewUserProfilepic.layer.masksToBounds = true
        
        
        self.lblAddress.text = addressText
        self.lblDropOffUser.text = " \(nameOfUser)"
        let imgresource = ImageResource(downloadURL: URL(string: imageUrlString)!)
      //  imgViewUserProfilepic.kf.setImage(with: imgresource)
        imgViewUserProfilepic.kf.setImage(with: imgresource, placeholder: UIImage(named: "default-user"), options: nil, progressBlock: nil)

        
        let camera = GMSCameraPosition.camera(withTarget: destCoord, zoom: 10.0)
        self.mapView?.animate(to: camera)
       let marker = GMSMarker()
        marker.position = destCoord
        marker.icon  = UIImage(named: "Start-pin")
        marker.map = mapView
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    @IBAction func btnNavigateAction(_ sender: UIButton) {
        delegate?.tappedNavigate(str: "tapped Navigate")
        self.removeAnimate()
    }
    
    
    
    
}
