//
//  FeedWriteVM.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/23.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

class FeedWriteVM: ObservableObject {
    var subscriptions = Set<AnyCancellable>()

    @Published var isFeedWriteFailed: Bool = false
    @Published var isSuccess: Bool = false
    @Published var isDeleteSuccess: Bool = false

    func fileUpload(fileImg: [UIImage]?, completion: @escaping ([String]) -> Void) {

        guard let fileImg = fileImg else {
            completion([])
            return
        }
        FeedApiService.fileUpload(fileImg: fileImg)
            .sink { complete in
                print("FeedWriteVM completion: \(complete)")
                switch complete {
                case .finished:
                    print("FeedWriteVM completion: finished")
                    
                case .failure(let error):
                    print("FeedWriteVM completion: failure(\(error))")
                    self.isFeedWriteFailed = true
                }
            } receiveValue: { result in
                if let fileUrls = result.fileUrls {
                    completion(fileUrls)
                }
            }
            .store(in: &subscriptions)

    }
    
    func insertFeed(fileImg: [UIImage]? = nil, info: [String: Any], completion: @escaping () -> Void) {
        var addInfo = info
        
        self.fileUpload(fileImg: fileImg) { [self] fileUrls in
            for (index,item) in fileUrls.enumerated() {
                addInfo.updateValue(item, forKey: "img\(index + 1)")
            }
            
            FeedApiService.insertFeed(info: addInfo)
                .sink { complete in
                    print("FeedWriteVM completion: \(complete)")
                    switch complete {
                    case .finished:
                        print("FeedWriteVM completion: finished")
                    case .failure(let error):
                        print("FeedWriteVM completion: failure(\(error))")
                        self.isFeedWriteFailed = true
                    }
                } receiveValue: { result in
                    if result.resultCode == 200 {
                        self.isSuccess = true
                        completion()
                    }
                }
                .store(in: &self.subscriptions)
        }
        
    }
    
    func updateFeed(fileImg: [UIImage]? = nil, info: [String: Any], completion: @escaping () -> Void) {
        var addInfo = info
        
        self.fileUpload(fileImg: fileImg) { [self] fileUrls in
            for (index,item) in fileUrls.enumerated() {
                addInfo.updateValue(item, forKey: "img\(index + 1)")
            }
            
            FeedApiService.updateFeed(info: addInfo)
                .sink { complete in
                    print("FeedWriteVM completion: \(complete)")
                    switch complete {
                    case .finished:
                        print("FeedWriteVM completion: finished")
                    case .failure(let error):
                        print("FeedWriteVM completion: failure(\(error))")
                        self.isFeedWriteFailed = true
                    }
                } receiveValue: { result in
                    if result.resultCode == 200 {
                        self.isSuccess = true
                        completion()
                    }
                }
                .store(in: &self.subscriptions)
        }
        
    }
    
    func removeFeed(info: [String: Any], completion: @escaping () -> Void) {
        FeedApiService.removeFeed(info: info)
            .sink { complete in
                print("FeedWriteVM completion: \(complete)")
                switch complete {
                case .finished:
                    print("FeedWriteVM completion: finished")
                case .failure(let error):
                    print("FeedWriteVM completion: failure(\(error))")
                    self.isFeedWriteFailed = true
                }
            } receiveValue: { result in
                if result.resultCode == 200 {
                    self.isDeleteSuccess = true
                    completion()
                }
            }
            .store(in: &self.subscriptions)
        
    }
    
}
