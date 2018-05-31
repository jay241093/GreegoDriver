//
//  PopUpConfirmDropOff.swift
//  PopUp
//
//  Created by Vipul on 20/04/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit
import Kingfisher
protocol ConfirmDropOffDelegate {
    func tappedOnConfirmDropOff(str:String)
}

class PopUpConfirmDropOff: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblArrivedAtLocation: UILabel!
    
    var delegate : ConfirmDropOffDelegate?
    var imgString  = ""
    var nameOfuser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.masksToBounds = true
        
        let imageres = ImageResource(downloadURL: URL(string: imgString)!)
       // imageView.kf.setImage(with: imageres)
        
        imageView.kf.setImage(with: imageres, placeholder: UIImage(named: "default-user"), options: nil, progressBlock: nil)

        
        
        
        lblArrivedAtLocation.text = "Did You Arrived at \(nameOfuser)'s Destination"
        
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
    @IBAction func btnConfirmDropOffAction(_ sender: Any) {
        
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //
        //        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverRatingVC") as! DriverRatingVC
        //        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        delegate?.tappedOnConfirmDropOff(str: "userTapped Confirm DropOff")
        
        self.removeAnimate()
    }
    @IBAction func btnCancelAction(_ sender: Any) {
        self.removeAnimate()
    }
    
    
    
    
}
