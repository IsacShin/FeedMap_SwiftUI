//
//  UserListRawData.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/19.
//

import Foundation

struct UserListRawData: Codable {
    var list: [UserRawData]?
}

struct UserRawData: Codable, Identifiable {
    var uuid = UUID()
    var id : Int?
    var memid: String?
    var password: String?
    var name: String?
    var profileUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case memid
        case password
        case name
        case profileUrl
    }
}
