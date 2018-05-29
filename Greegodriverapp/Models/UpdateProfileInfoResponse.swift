//
//  UpdateProfileInfoResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 14/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
public struct UpdateProfileInfoResponse: Codable {
    public let data: DataClassss
    public let errorCode: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

public struct DataClassss: Codable {
    public let profileStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case profileStatus = "profile_status"
    }
}
