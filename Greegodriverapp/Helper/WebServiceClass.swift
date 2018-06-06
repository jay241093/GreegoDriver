//
//  WebServiceClass.swift
//  greegotaxiapp
//
//  Created by mac on 07/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class WebServiceClass: NSObject
{
    
//let BaseURL = "http://54.144.110.21/api/"
let BaseURL = "http://kroslinkstech.in/greego/public/api/"
// let BaseURL = "http://54.144.110.21/api/"
    static let sharedInstance : WebServiceClass = {
        let instance = WebServiceClass()
        return instance
    }()
    
    func nointernetconnection()
    {
        let button2Alert: UIAlertView = UIAlertView(title: nil, message: "Please check your internet connection",delegate: nil, cancelButtonTitle: "OK")
        button2Alert.show()
        
        
    }
    
//    func callAPIWithURLWithHandler(requestType:String , parameters:Dictionary<String, Any> , completionHandler :@escaping (_ success:Bool,_ responseData:Any,_ urlResponse:HTTPURLResponse) -> Void) {
//
//
//        let apiUrl:String = BaseURL + requestType
//        print(apiUrl)
//
//
//        var MutableUrlRequest = URLRequest.init(url: URL.init(string: apiUrl)!)
//        MutableUrlRequest.httpMethod = "POST"
//        MutableUrlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        MutableUrlRequest.timeoutInterval = 10.0
//
//        if(UserDefaults.standard.object(forKey: "AppToken") != nil) {
//
//            let dict = UserDefaults.standard.value(forKey: "AppToken") as! Dictionary<String,Any>
//            let headerKey = dict["access_token"] as! String //refresh_token   access_token
//            let headerValue:String = "Bearer " + headerKey
//            MutableUrlRequest.setValue(headerValue, forHTTPHeaderField:"Authorization")
//
//        }
//
//        if (parameters.count > 0) {
//            MutableUrlRequest.setValue(parameters["Authorization"] as! String?, forHTTPHeaderField:"Authorization")
//        }
//
//
//
//        let task = URLSession.shared.dataTask(with: MutableUrlRequest) { data, response, error in
//
//            guard response != nil  else {
//                completionHandler(false,error?.localizedDescription ?? "",HTTPURLResponse.init())
//                return
//            }
//
//            guard let data = data, error == nil else {
//                // check for fundamental networking error
//                print("error=\(String(describing: error))")
//                completionHandler(false,error?.localizedDescription ?? "",HTTPURLResponse.init())
//                return
//            }
//
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(String(describing: responseString))")
//            completionHandler(true,data,response! as! HTTPURLResponse)
//        }
//
//        task.resume()
//    }
//

}
