//
//  DefaultsHelper.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 03/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

//MARK: UserDefault keys
//      it helps accessing userdefault spainless
//HOW to USE:
//This is a key      let alreaySignedInKey = DefaultsKey<Bool>("alreadySignedIn")
//This is how you access it
//                   Defaults[alreaySignedInKey._key] = false


extension DefaultsKeys {
    static let fcmTokenkey =  DefaultsKey<String>("FCMToken")
    static let deviceTokenKey = DefaultsKey<String>("devicetoken")
    static let profileStatusKey = DefaultsKey<Int>("profilestatus")
    static let isAleradyLoggedIn = DefaultsKey<Bool>("alreadyLoggedIn")
    static let isAprrovedKey = DefaultsKey<Int>("isaprroved")
    static let CardTokenKey = DefaultsKey<String>("cardToken")
    static let CurrentTripIDKey = DefaultsKey<Int>("CurrentTripIDKey")
    static let CurrentTripStatusKey = DefaultsKey<Int>("currentTripStatusKey")



    static let profileImageString = DefaultsKey<String>("profileImgKey")

    static let Driverid = DefaultsKey<Int>("Driverid")
    
    static let SelectedNavigationAppKey = DefaultsKey<Int>("NavigationOptionKey")
    static let iswazeInstalled = DefaultsKey<Bool>("iswazeInstalled")
    static let isGoogleMapsInstalled = DefaultsKey<Bool>("isGoogleMapsInstalled")
    static let isOnOffBtnON = DefaultsKey<Bool>("isOnOffBtnON")

    

    
}
func initDefaults(){
   Defaults[.SelectedNavigationAppKey] = 2
    Defaults[.profileImageString] = "https://Google.com"


}

func AlertBuilder(title:String, message: String) -> UIAlertController{
  
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alert
}
