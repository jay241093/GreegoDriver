//
//  DriverProfileRespModel.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 05/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
struct DriverProfileRespModel: Codable {
    let data: data?
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct data: Codable {
    let id: Int?
    let name, lastname, email, dob: String?
    let contactNumber, city, profilePic, promocode: String?
    let legalFirstname, legalMiddlename, legalLastname, socialSecurityNumber: String?
    let isSedan, isSuv, isVan, isAuto: Int?
    let isManual, currentStatus, verified, emailVerified: Int?
    let isAgreed, isIphone, profileStatus, isApprove: Int?
    let deviceID, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, lastname, email, dob
        case contactNumber = "contact_number"
        case city
        case profilePic = "profile_pic"
        case promocode
        case legalFirstname = "legal_firstname"
        case legalMiddlename = "legal_middlename"
        case legalLastname = "legal_lastname"
        case socialSecurityNumber = "social_security_number"
        case isSedan = "is_sedan"
        case isSuv = "is_suv"
        case isVan = "is_van"
        case isAuto = "is_auto"
        case isManual = "is_manual"
        case currentStatus = "current_status"
        case verified
        case emailVerified = "email_verified"
        case isAgreed = "is_agreed"
        case isIphone = "is_iphone"
        case profileStatus = "profile_status"
        case isApprove = "is_approve"
        case deviceID = "device_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
