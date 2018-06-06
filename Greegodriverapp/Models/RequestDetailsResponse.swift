//
//  RequestDetailsResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 08/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
public struct RequestDetailsResponse: Codable {
    public let data: dataa
    public let errorCode: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

public struct dataa: Codable {
    public let body: Body
    public let vehicelModel, vehicelName: String
    public let vehicleYear: Int
    public let vehicleColor: String
    
    enum CodingKeys: String, CodingKey {
        case body
        case vehicelModel = "vehicel_model"
        case vehicelName = "vehicel_name"
        case vehicleYear = "vehicle_year"
        case vehicleColor = "vehicle_color"
    }
}

public struct Body: Codable {
    public let id, userID, userVehicleID: Int
    public let fromAddress: String
    public let fromLat, fromLng: Double
    public let toAddress: String
    public let toLat, toLng: Double
    public let totalEstimatedTravelTime:String
    public let totalEstimatedTripCost:Double
    public let requestStatus: Int
    public let createdAt, updatedAt: String
    public let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case userVehicleID = "user_vehicle_id"
        case fromAddress = "from_address"
        case fromLat = "from_lat"
        case fromLng = "from_lng"
        case toAddress = "to_address"
        case toLat = "to_lat"
        case toLng = "to_lng"
        case totalEstimatedTravelTime = "total_estimated_travel_time"
        case totalEstimatedTripCost = "total_estimated_trip_cost"
        case requestStatus = "request_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
    }
}

public struct User: Codable {
    public let id: Int
    public let name, email, lastname, contactNumber: String
    public let city, state, profilePic, promocode: String?
    public let invitecode: String
    public let verified, emailVerified, isIphone, isAgreed: Int
    //public let isDeactivated: Int
    public let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, lastname
        case contactNumber = "contact_number"
        case city, state
        case profilePic = "profile_pic"
        case promocode, invitecode, verified
        case emailVerified = "email_verified"
        case isIphone = "is_iphone"
        case isAgreed = "is_agreed"
       // case isDeactivated = "is_deactivated"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
