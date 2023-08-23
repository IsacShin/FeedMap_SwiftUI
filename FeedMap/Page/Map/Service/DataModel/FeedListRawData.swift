//
//  FeedListRawData.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import Foundation

struct FeedListRawData: Codable {
    var list: [FeedRawData]?
}

struct FeedRawData: Codable {
    var id : Int?
    var title: String?
    var addr: String?
    var date: String?
    var comment: String?
    var latitude: String?
    var longitude: String?
    var memid: String?
    var img1: String?
    var img2: String?
    var img3: String?
}
