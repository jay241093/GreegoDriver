//
//  popUpPhoneCall.swift
//  PopUp
//
//  Created by Vipul on 19/04/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit
protocol callPopUpProtocol {
    func tappedCallBtn()
}
class popUpPhoneCall: UIViewController {

    
    @IBOutlet weak var btnCall: UIButton!
    var delegate:callPopUpProtocol?
    var nameToshow:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnCall.setTitle("Yes,Call \(nameToshow!)", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnYesCall(_ sender: Any) {
        
        delegate?.tappedCallBtn()
        
    }
    
    @IBAction func btnNoCall(_ sender: Any) {
        self.removeAnimate()
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
}
