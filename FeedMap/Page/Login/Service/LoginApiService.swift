//
//  LoginApiService.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/19.
//

import Foundation
import Alamofire
import Combine

enum LoginApiService {
    static func getMember(id: String, password: String) -> AnyPublisher<UserListRawData, AFError> {
        return ApiClient.shared.session
            .request(LoginRouter.idLogin(id: id, password: password))
            .publishDecodable(type: UserListRawData.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func removeId(id: String) -> AnyPublisher<FeedUpdateRawData, AFError> {
        return ApiClient.shared.session
            .request(LoginRouter.removeId(id: id))
            .publishDecodable(type: FeedUpdateRawData.self)
            .value()
            .eraseToAnyPublisher()
    }
}
