//
//  JoinRawData.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/21.
//

import Foundation

struct FileUploadRawData: Codable {
    var fileUrls: [String]?
}

struct JoinRawData: Codable {
    var resultCode: Int?
}
