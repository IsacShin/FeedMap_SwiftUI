//
//  JoinApiService.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/21.
//

import Foundation
import Alamofire
import Combine
import UIKit

enum JoinApiService {
    static func fileUpload(fileImg: UIImage) -> AnyPublisher<FileUploadRawData, AFError> {
        let router = JoinRouter.fileUpload(fileImg)
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
    
    static func insertMember(info: [String: Any]) -> AnyPublisher<JoinRawData, AFError> {
        
        return ApiClient.shared.session
            .request(JoinRouter.insertMember(info))
            .publishDecodable(type: JoinRawData.self)
            .value()
            .eraseToAnyPublisher()
        
    }
    
    static func getMemberId(info: [String: Any]) -> AnyPublisher<UserListRawData, AFError> {
        
        return ApiClient.shared.session
            .request(JoinRouter.getMemberId(info))
            .publishDecodable(type: UserListRawData.self)
            .value()
            .eraseToAnyPublisher()
        
    }

}
