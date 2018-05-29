//
//  ViewController.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 4/6/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import  SwiftyUserDefaults
import Rswift
import SVProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "start")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
         
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        StartSpinner()

        if Defaults[.isAleradyLoggedIn] == true{
       UserDefaults.standard.removeObject(forKey:"isdashbord")
            performSegue(withIdentifier: "ToMainMapVC", sender: nil)
            
        }else{
            print(Defaults[.isAleradyLoggedIn])
            StopSpinner()
            initDefaults()

        }
        StopSpinner()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        StopSpinner()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

