//
//  UpdateLocationRespose.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 05/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
struct UpdateLocationRespose: Codable {
    let data: datanode
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct datanode: Codable {
    let driverID: Int
    let lat, lng, updatedAt, createdAt: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case driverID = "driver_id"
        case lat, lng
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
