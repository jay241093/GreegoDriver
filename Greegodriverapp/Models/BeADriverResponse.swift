//
//  BeADriverResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 08/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
public struct BeAdriverResponse: Codable {
    public let data: DataClass?
    public let errorCode: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

public struct DataClass: Codable {
    public let id, requestID, userID, driverID: Int
    public let status: Int
    public let totalEstimatedTripCost: Double
    public let totalEstimatedTravelTime: String
    public let createdAt, updatedAt: AtedAt
    public let cardToken: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case requestID = "request_id"
        case userID = "user_id"
        case driverID = "driver_id"
        case status
        case totalEstimatedTripCost = "total_estimated_trip_cost"
        case totalEstimatedTravelTime = "total_estimated_travel_time"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cardToken = "card_token"
    }
}

public struct AtedAt: Codable {
    public let date: String
    public let timezoneType: Int
    public let timezone: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case timezoneType = "timezone_type"
        case timezone
    }
}
