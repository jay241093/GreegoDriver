//
//  PopUpTipDriver.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 16/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
protocol  tipthedriverProtocol {
    
    func TipTheDriver(ammount:Double)
}

class PopUpTipDriver: UIViewController {
    var delegate : tipthedriverProtocol?

    @IBOutlet weak var tipTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedTipDriver(_ sender: UIButton) {
        self.removeAnimate()

        delegate?.TipTheDriver(ammount: Double(tipTextField.text!)!)
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
