//
//  DriverRatingVC.swift
//  MyGreegoApp
//
//  Created by Pish Selarka on 20/04/18.
//  Copyright © 2018 Techrevere. All rights reserved.
//

import UIKit
import FloatRatingView
import Kingfisher
import Alamofire
import SwiftyUserDefaults
import SwiftyJSON
import Stripe
class DriverRatingVC: UIViewController,FloatRatingViewDelegate,tipthedriverProtocol{
  
    
    
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRatingText: UILabel!
    @IBOutlet weak var profileimageView: UIImageView!
    @IBOutlet weak var lblAmmount: UILabel!
    @IBOutlet weak var lblTipAmmount: UILabel!
    @IBOutlet weak var lblTotalAmmount: UILabel!
    
    
    var str = Stripe()
    var dropOffRespose:TripStatusResponse?
    var tripAmmount = 0.0
    var tipAmmount = 0.0
    var totalCost = 0.0
    var profilepicString = ""
    var currentRating:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.delegate = self
        ratingView.halfRatings = true
        //self.ratingView.delegate = self
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        lblAmmount.text = String(format: "$ %.2f", tripAmmount)
         lblTotalAmmount.text = String(format: "$ %.2f", tripAmmount)
        profileimageView.layer.cornerRadius = profileimageView.frame.size.width / 2
        profileimageView.layer.masksToBounds = true
        
        let resource = ImageResource(downloadURL: URL(string: profilepicString)!)
      //  profileimageView.kf.setImage(with: resource)
        profileimageView.kf.setImage(with: resource, placeholder: UIImage(named: "default-user"), options: nil, progressBlock: nil)

        
    }
    //MARK:- Rating Delegate
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
//        self.lblRatingText.text = String(format: "%.2f", rating)
        currentRating = rating
    }
    
    @IBAction func Doneaction(_ sender: Any) {
        StartSpinner()
        
        guard let tripresp = dropOffRespose else{
            let alert = AlertBuilder(title: "oops", message: "TripResponse could not be parsed")
            present(alert, animated: true, completion: nil)
            return
        }
        
        let parmm:Parameters = [
            "trip_id": Defaults[.CurrentTripIDKey],
            "rating": currentRating
            ]
        let token = Defaults[.deviceTokenKey]
        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
        
        
        Alamofire.request(WebServiceClass().BaseURL + "driver/add/userrating", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON { (dataresponse) in
            switch dataresponse.result{
            case .success(let resp):
                print("success add/triptransaction")
                print(resp)
                if JSON(resp)["error_code"] == 0{
                    self.openPopup()
                    StopSpinner()
                    
                }
                StopSpinner()
                
                
            case .failure(let err):
                print("Some Error is there \(err.localizedDescription)")
                StopSpinner()
                let alert = AlertBuilder(title: "oops", message: "Could not send rating \n Try Again")
                self.present(alert, animated: true, completion: nil)
            }
        }
        
//        let parmm:Parameters = [
//            "trip_id": Defaults[.CurrentTripIDKey],
//            "tip_amount": tipAmmount,
//            "trip_user_rating":currentRating,
//            "transaction_id":"1",
//            "user_card_id": Defaults[.CardTokenKey],
//            "payment_status":"1",
//            "transaction_amount":tripAmmount,
//            "transaction_description":"This is transaction desc",
//            ]
//        let token = Defaults[.deviceTokenKey]
//        let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
//
//
//        Alamofire.request(WebServiceClass().BaseURL + "driver/add/triptransaction", method: .post, parameters: parmm, encoding: JSONEncoding.default, headers: headers).responseJSON { (dataresponse) in
//            switch dataresponse.result{
//            case .success(let resp):
//                print("success add/triptransaction")
//                print(resp)
//                if JSON(resp)["error_code"] == 0{
//                    self.openPopup()
//                    StopSpinner()
//
//                }
//                StopSpinner()
//
//
//            case .failure(let err):
//                print("Some Error is there \(err.localizedDescription)")
//                StopSpinner()
//                let alert = AlertBuilder(title: "oops", message: "Could not send transaction \n Try Again")
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    func openPopup(){
        let popOverCallVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpUberLyft") as! PopUpUberLyft
        self.addChildViewController(popOverCallVC)
        popOverCallVC.view.frame = self.view.frame
        self.view.center = popOverCallVC.view.center
        self.view.addSubview(popOverCallVC.view)
        popOverCallVC.didMove(toParentViewController: self)
        
    }
    
    @IBAction func tappedAddaTip(_ sender: UITapGestureRecognizer) {
        
        //open pop to get tip ammount
        
        let PopUpTipDriver = self.storyboard?.instantiateViewController(withIdentifier: "PopUpTipDriver") as! PopUpTipDriver
        self.addChildViewController(PopUpTipDriver)
        PopUpTipDriver.view.frame = self.view.frame
        PopUpTipDriver.delegate = self
        
       
        
        self.view.center = PopUpTipDriver.view.center
        self.view.addSubview(PopUpTipDriver.view)
        PopUpTipDriver.didMove(toParentViewController: self)
    
}
    func TipTheDriver(ammount: Double) {
        tipAmmount = ammount
        lblTipAmmount.text = String(format: "$ %.2f", ammount)
        lblTotalAmmount.text = String(format: "$ %.2f", ammount + tripAmmount)
        

        
    }
}
