//
//  UploadDocsResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 04/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
struct UploadDocsResponse: Codable {
    let data: DataNode
    let errorCode: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

struct DataNode: Codable {
    let profileStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case profileStatus = "profile_status"
    }
}
