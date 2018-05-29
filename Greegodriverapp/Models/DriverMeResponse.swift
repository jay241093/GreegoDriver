//
//  DriverMeResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 07/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation

public struct DriverMeResonse: Codable {
    public let data: dataNode
    public let errorCode: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

public struct dataNode: Codable {
    public let id: Int?
    public let contactNumber, email, name, lastname: String?
    public let isAgreed, isApprove: Int?
    public let promocode: String?
    public let profileStatus: Int?
    public let email_verifed: Int?
    public let personalInformation: PersonalInformation?
    public let shippingAdress: ShippingAdress?
    public let documents: Documents?
    public let bankInformation: BankInformation?
    public let profilePic: String?
    public let type: TypeClass?
    
    enum CodingKeys: String, CodingKey {
        case id
        case contactNumber = "contact_number"
        case email, name, lastname
        case isAgreed = "is_agreed"
        case isApprove = "is_approve"
        case promocode
        case profileStatus = "profile_status"
        case email_verifed = "email_verifed"
        case personalInformation = "personal_information"
        case shippingAdress = "shipping_adress"
        case documents
        case bankInformation = "bank_information"
        case profilePic = "profile_pic"
        case type
    }
}

public struct BankInformation: Codable {
    public let id, driverID: Int?
    public let routingNumber, accountNumber, stripeAccountID, createdAt: String?
    public let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case driverID = "driver_id"
        case routingNumber = "routing_number"
        case accountNumber = "account_number"
        case stripeAccountID = "stripe_account_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct Documents: Codable {
    public let id, driverID: Int?
    public let verificationDocument, autoissuranceDocument, homeissuranceDocument, uberpaycheckDocument: String?
    public let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case driverID = "driver_id"
        case verificationDocument = "verification_document"
        case autoissuranceDocument = "autoissurance_document"
        case homeissuranceDocument = "homeissurance_document"
        case uberpaycheckDocument = "uberpaycheck_document"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct PersonalInformation: Codable {
    public let legalFirstname, legalMiddlename, legalLastname, socialSecurityNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case legalFirstname = "legal_firstname"
        case legalMiddlename = "legal_middlename"
        case legalLastname = "legal_lastname"
        case socialSecurityNumber = "social_security_number"
    }
}

public struct ShippingAdress: Codable {
    public let id, driverID: Int?
    public let street, apt, city: String?
    public let zipcode: Int?
    public let state, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case driverID = "driver_id"
        case street, apt, city, zipcode, state
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct TypeClass: Codable {
    public let isSedan, isSuv, isVan, isAuto: Int?
    public let isManual: Int?
    
    enum CodingKeys: String, CodingKey {
        case isSedan = "is_sedan"
        case isSuv = "is_suv"
        case isVan = "is_van"
        case isAuto = "is_auto"
        case isManual = "is_manual"
    }
}
