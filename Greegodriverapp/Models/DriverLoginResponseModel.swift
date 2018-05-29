//
//  DriverLoginResponseModel.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 03/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
struct DriverLoginResponse: Codable {
    let data: DataClass
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct DataClass: Codable {
    let contactNumber: String
    let isAgreed:Int?
    let otp: Int?
    let token: String
    let profileStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case contactNumber = "contact_number"
        case isAgreed = "is_agreed"
        case otp, token
        case profileStatus = "profile_status"
    }
}
