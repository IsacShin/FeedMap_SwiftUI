//
//  FeedService.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/23.
//

import Foundation
import Alamofire
import Combine
import UIKit

enum FeedApiService {
    static func fileUpload(fileImg: [UIImage]) -> AnyPublisher<FileUploadRawData, AFError> {
        let router = FeedRouter.fileUpload(fileImg)
        return ApiClient.shared.session
            .upload(multipartFormData:
                        router.multipartFormData,
                    with:
                        router)
            .uploadProgress { pr in
                print(pr.fractionCompleted.description)
            }
            .publishDecodable(type: FileUploadRawData.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    static func insertFeed(info: [String: Any]) -> AnyPublisher<FeedUpdateRawData, AFError> {
        
        return ApiClient.shared.session
            .request(FeedRouter.insertFeed(info))
            .publishDecodable(type: FeedUpdateRawData.self)
            .value()
            .eraseToAnyPublisher()
        
    }
    
    static func updateFeed(info: [String: Any]) -> AnyPublisher<FeedUpdateRawData, AFError> {
        
        return ApiClient.shared.session
            .request(FeedRouter.updateFeed(info))
            .publishDecodable(type: FeedUpdateRawData.self)
            .value()
            .eraseToAnyPublisher()
        
    }
    
    static func removeFeed(info: [String: Any]) -> AnyPublisher<FeedUpdateRawData, AFError> {
        
        return ApiClient.shared.session
            .request(FeedRouter.removeFeed(info))
            .publishDecodable(type: FeedUpdateRawData.self)
            .value()
            .eraseToAnyPublisher()
        
    }
    
    static func insertReport(info: [String: Any]) -> AnyPublisher<FeedUpdateRawData, AFError> {
        
        return ApiClient.shared.session
            .request(FeedRouter.insertReport(info))
            .publishDecodable(type: FeedUpdateRawData.self)
            .value()
            .eraseToAnyPublisher()
        
    }


}
