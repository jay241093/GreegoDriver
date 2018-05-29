//
//  NotificationModel.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 08/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation
public struct NotificationModel: Codable {
    public let gcmMessageID: String
    public let aps: Aps
    public let requestID: String
    
    enum CodingKeys: String, CodingKey {
        case gcmMessageID = "gcm.message_id"
        case aps
        case requestID = "request_id"
    }
}

public struct Aps: Codable {
    public let sound: String
    public let alert: Alert
}

public struct Alert: Codable {
    public let body, title: String
}
