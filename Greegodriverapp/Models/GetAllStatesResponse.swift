//
//  File.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 14/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
public struct GetAllStatesResponse: Codable {
    public let data: [Datum]
    public let errorCode: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

public struct Datum: Codable {
    public let id: Int
    public let stateName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case stateName = "state_name"
    }
}
