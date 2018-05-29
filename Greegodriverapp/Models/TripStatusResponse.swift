//
//  TripStatusResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 09/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
public struct TripStatusResponse: Codable {
    public let data: aaaa
    public let errorCode: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

public struct aaaa: Codable {
    public let id, requestID, userID, driverID: Int
    public let status:Int
    public let actualTripAmount:Double?
    public let actualTripMiles: Double?
    public let tipAmount, actualTripTravelTime, tripDriverRating, tripUserRating: Double?
    public let paymentStatus: Int
    public let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case requestID = "request_id"
        case userID = "user_id"
        case driverID = "driver_id"
        case status
        case actualTripAmount = "actual_trip_amount"
        case actualTripMiles = "actual_trip_miles"
        case tipAmount = "tip_amount"
        case actualTripTravelTime = "actual_trip_travel_time"
        case tripDriverRating = "trip_driver_rating"
        case tripUserRating = "trip_user_rating"
        case paymentStatus = "payment_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
