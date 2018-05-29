//
//  NavigationSettings.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 12/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
protocol navigationSettingsDelegate {
    func selectedNavigatonApp()
}

class NavigationSettings: UIViewController {
    
    @IBOutlet weak var appleview: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var lblWazeInstalled: UIButton!
    @IBOutlet weak var lblGoogleMapsInstalled: UIButton!
    
    
    @IBOutlet weak var wazeview: UIView!
    
    @IBOutlet weak var googleview: UIView!
    var delegate:navigationSettingsDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap1 = UITapGestureRecognizer()
        
        tap1.addTarget(self, action: #selector(wazeaction))
        wazeview.addGestureRecognizer(tap1)
       
        let tap2 = UITapGestureRecognizer()
        
        tap2.addTarget(self, action: #selector(googlemap))
        googleview.addGestureRecognizer(tap2)
      
        
        let tap3 = UITapGestureRecognizer()

        
        tap3.addTarget(self, action: #selector(Applemap))
        appleview.addGestureRecognizer(tap3)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setShadow(view: header)
        if Defaults[.isGoogleMapsInstalled] == true{
            lblGoogleMapsInstalled.isHidden = true
        }else{
            lblGoogleMapsInstalled.setTitle("Install", for: .normal)
        }
        
        if Defaults[.iswazeInstalled] == true{
            lblWazeInstalled.isHidden = true
        }else{
            lblWazeInstalled.setTitle("Install", for: .normal)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func TappedOnwaze(_ sender: Any) {
        let installWazeLink = "itms://itunes.apple.com/us/app/apple-store/id323229106?mt=8"
        
        if Defaults[.iswazeInstalled] == true{
            // select and go back
            Defaults[.SelectedNavigationAppKey] =  1
            delegate?.selectedNavigatonApp()
            self.navigationController?.popViewController(animated: true)
            
        }else{
            // help use install waze
            UIApplication.shared.openURL(URL(string: installWazeLink)!)
            
        }
        
        
    }
    
    @objc func Applemap()
    {
        Defaults[.SelectedNavigationAppKey] =  2
        delegate?.selectedNavigatonApp()
        self.navigationController?.popViewController(animated: true)

    }
    @objc func googlemap()
  {
    let installGoogleMapsLink = "itms://itunes.apple.com/us/app/apple-store/id585027354?mt=8"
    
    if Defaults[.isGoogleMapsInstalled] == true{
        Defaults[.SelectedNavigationAppKey] =  0
        delegate?.selectedNavigatonApp()
        self.navigationController?.popViewController(animated: true)
        
        
    }else{
        // help use install google maps
        UIApplication.shared.openURL(URL(string: installGoogleMapsLink)!)
    }
    
    }
    
    @objc func wazeaction()
   {
    let installWazeLink = "itms://itunes.apple.com/us/app/apple-store/id323229106?mt=8"
    
    if Defaults[.iswazeInstalled] == true{
        // select and go back
        Defaults[.SelectedNavigationAppKey] =  1
        delegate?.selectedNavigatonApp()
        self.navigationController?.popViewController(animated: true)
        
    }else{
        // help use install waze
        UIApplication.shared.openURL(URL(string: installWazeLink)!)
        
    }
    
    
    
    }
    
    
    
    
    @IBAction func tappedOnGoogleMaps(_ sender: Any) {
        
        let installGoogleMapsLink = "itms://itunes.apple.com/us/app/apple-store/id585027354?mt=8"
        
        if Defaults[.isGoogleMapsInstalled] == true{
            Defaults[.SelectedNavigationAppKey] =  0
            delegate?.selectedNavigatonApp()
            self.navigationController?.popViewController(animated: true)
            
            
        }else{
            // help use install google maps
            UIApplication.shared.openURL(URL(string: installGoogleMapsLink)!)
        }
        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
