//
//  stateRateResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 11/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation

public struct StateRateResponse: Codable {
    public let data: dataaaa
    public let errorCode: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

public struct dataaaa: Codable {
    public let id, usaStateID:Int
    public let baseFee: Double?
    public let timeFee: Double?
    public let mileFee, cancelFee: Double?
    public let overmileFee: Double?
    public let isActive: Int?
    public let createdAt, updatedAt: String?
    public let greegoFee: Double?
    public let expressFee: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case usaStateID = "usa_state_id"
        case baseFee = "base_fee"
        case timeFee = "time_fee"
        case mileFee = "mile_fee"
        case cancelFee = "cancel_fee"
        case overmileFee = "overmile_fee"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case greegoFee = "greego_fee"
        case expressFee = "express_fee"
    }
}
