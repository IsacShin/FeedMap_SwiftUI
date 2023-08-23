//
//  MapApiService.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import Foundation
import Alamofire
import Combine

enum MapApiService {
    static func getAddrGeocode(info: [String: Any]) -> AnyPublisher<GeocodeRawData, AFError> {
        return ApiClient.shared.session
            .request(MapRouter.getAddrGeocode(info: info))
            .publishDecodable(type: GeocodeRawData.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func getFeedList(info: [String: Any]) -> AnyPublisher<FeedListRawData, AFError> {
        return ApiClient.shared.session
            .request(MapRouter.getFeedList(info: info))
            .publishDecodable(type: FeedListRawData.self)
            .value()
            .eraseToAnyPublisher()
    }
}
