

import UIKit

class PopupHome: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnConfirmArrival(_ sender: Any) {
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpConfirmArrival") as! popUpConfirmArrival
        self.addChildViewController(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParentViewController: self)
    }
    
    @IBAction func showPopup(_ sender: AnyObject) {
        
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpNoUser") as! popUpNoUser
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.center = popOverVC.view.center
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    @IBAction func showPhoneCall(_ sender: Any) {
        let popOverCallVC = self.storyboard?.instantiateViewController(withIdentifier: "popUpPhoneCall") as! popUpPhoneCall
        self.addChildViewController(popOverCallVC)
        popOverCallVC.view.frame = self.view.frame
        self.view.center = popOverCallVC.view.center
        self.view.addSubview(popOverCallVC.view)
        popOverCallVC.didMove(toParentViewController: self)
    }
    @IBAction func btnDropOffAction(_ sender: Any) {
//        let popUpDropOffvc = self.storyboard?.instantiateViewController(withIdentifier: "popUpDropOff") as! popUpDropOff
//        self.addChildViewController(popUpDropOffvc)
//        popUpDropOffvc.view.frame = self.view.frame
//        self.view.center  = popUpDropOffvc.view.center
//        self.view.addSubview(popUpDropOffvc.view)
//        popUpDropOffvc.didMove(toParentViewController: self)
    }
    @IBAction func btnShowUberLyft(_ sender: Any) {
        let popUpUberLyft = self.storyboard?.instantiateViewController(withIdentifier: "PopUpUberLyft") as! PopUpUberLyft
        self.addChildViewController(popUpUberLyft)
        popUpUberLyft.view.frame = self.view.frame
        self.view.center = popUpUberLyft.view.center
        self.view.addSubview(popUpUberLyft.view)
        popUpUberLyft.didMove(toParentViewController: self)
    }
    @IBAction func btnConfirmDropOffAction(_ sender: Any) {
        let popUpConfirmDropOff = self.storyboard?.instantiateViewController(withIdentifier: "PopUpConfirmDropOff") as! PopUpConfirmDropOff
        self.addChildViewController(popUpConfirmDropOff)
        popUpConfirmDropOff.view.frame = self.view.frame
        self.view.center = popUpConfirmDropOff.view.center
        self.view.addSubview(popUpConfirmDropOff.view)
        popUpConfirmDropOff.didMove(toParentViewController: self)
    }
    
}

