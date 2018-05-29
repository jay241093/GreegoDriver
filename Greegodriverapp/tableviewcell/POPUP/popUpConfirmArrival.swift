//
//  popUpConfirmArrival.swift
//  PopUp
//
//  Created by Vipul on 18/04/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Alamofire
import  Kingfisher
protocol  comfirmm {
    
    func ConfirmArrival(str:String)
}

class popUpConfirmArrival: UIViewController {

    
    var delegate : comfirmm?
    var address = ""
    var personImage = #imageLiteral(resourceName: "default-user")
    var personImageString = "a"
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imgUserPic: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.addressLabel.text = address
        self.imgUserPic.image = personImage
        let resource = ImageResource(downloadURL: URL(string: personImageString)!)
        //imgUserPic.kf.setImage(with: resource)
        imgUserPic.kf.setImage(with: resource, placeholder: UIImage(named: "default-user"), options: nil, progressBlock: nil)

        imgUserPic.layer.cornerRadius = imgUserPic.frame.size.height / 2
        imgUserPic.layer.masksToBounds = true
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
    }
    @IBAction func ConfirmArrivalAction(_ sender : AnyObject){
       self.removeAnimate()
//        changeTripStatus()
        
        delegate?.ConfirmArrival(str: "hello")
        
        
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
