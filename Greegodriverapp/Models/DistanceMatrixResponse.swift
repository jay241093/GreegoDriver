//
//  DistanceMatrixResponse.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 11/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import Foundation

public struct DistanceMatrixResponse: Codable {
    public let destinationAddresses, originAddresses: [String]
    public let rows: [Row]
    public let status: String
    
    enum CodingKeys: String, CodingKey {
        case destinationAddresses = "destination_addresses"
        case originAddresses = "origin_addresses"
        case rows, status
    }
}

public struct Row: Codable {
    public let elements: [Element]
}

public struct Element: Codable {
    public let distance, duration: Distancee
    public let status: String
}

public struct Distancee: Codable {
    public let text: String
    public let value: Int
}
