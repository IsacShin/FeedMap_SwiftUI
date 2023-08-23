//
//  GeocodeRawData.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import Foundation

struct GeocodeRawData: Codable {
    var results: [AddrRawData]?
}

struct AddrRawData: Codable {
    var geometry: GeometryRawData?
    var formatted_address: String?
}

struct GeometryRawData: Codable {
    var location: LocationRawData?
}

struct LocationRawData: Codable {
    let lat: Double?
    let lng: Double?
}
