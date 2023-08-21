//
//  JoinVM.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/20.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

class JoinVM: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    var nameCheck = PassthroughSubject<Bool, Never>()
    var idCheck = PassthroughSubject<Bool, Never>()
    var pwdCheck = PassthroughSubject<Bool, Never>()
    var pwdConfirmCheck = PassthroughSubject<Bool, Never>()
    var termCheck = PassthroughSubject<Bool, Never>()
    
    var isValidCheck1Publisher: AnyPublisher<(Bool, Bool, Bool), Never> {
        idCheck.combineLatest(pwdCheck, pwdConfirmCheck)
            .eraseToAnyPublisher()
    }
    
    var isValidCheck2Publisher: AnyPublisher<(Bool, Bool), Never> {
        nameCheck.combineLatest(termCheck)
            .eraseToAnyPublisher()
    }
    
    @Published var isJoinFailed: Bool = false
    @Published var isJoinedAlert: Bool = false
    @Published var isSuccess: Bool = false
    
    func fileUpload(fileImg: UIImage?, completion: @escaping ([String]) -> Void) {

        guard let fileImg = fileImg else {
            completion([])
            return
        }
        JoinApiService.fileUpload(fileImg: fileImg)
            .sink { complete in
                print("JoinVM completion: \(complete)")
                switch complete {
                case .finished:
                    print("JoinVM completion: finished")
                    
                case .failure(let error):
                    print("JoinVM completion: failure(\(error))")
                    self.isJoinFailed = true
                }
            } receiveValue: { result in
                if let fileUrls = result.fileUrls {
                    completion(fileUrls)
                }
            }
            .store(in: &subscriptions)

    }
    
    func getMemberId(info: [String: Any], completion: @escaping (UserListRawData) -> Void) {
        JoinApiService.getMemberId(info: info)
            .sink { complete in
                print("JoinVM completion: \(complete)")
                switch complete {
                case .finished:
                    print("JoinVM completion: finished")
                case .failure(let error):
                    print("JoinVM completion: failure(\(error))")
                    self.isJoinFailed = true
                }
            } receiveValue: { users in
                completion(users)
            }
            .store(in: &subscriptions)
    }
    
    func regist(fileImg: UIImage? = nil, info: [String: Any], completion: @escaping () -> Void) {
        self.getMemberId(info: info) { users in
            if users.list?.count ?? 0 > 0 {
                self.isJoinedAlert = true
            } else {
                var addInfo = info
                
                self.fileUpload(fileImg: fileImg) { fileUrls in
                    for (_,item) in fileUrls.enumerated() {
                        addInfo.updateValue(item, forKey: "profileUrl")
                    }
                    
                    JoinApiService.insertMember(info: addInfo)
                        .sink { complete in
                            print("JoinVM completion: \(complete)")
                            switch complete {
                            case .finished:
                                print("JoinVM completion: finished")
                                
                            case .failure(let error):
                                print("JoinVM completion: failure(\(error))")
                                self.isJoinFailed = true
                            }
                        } receiveValue: { result in
                            if result.resultCode == 200 {
                                completion()
                            }
                        }
                        .store(in: &self.subscriptions)
                }
            }
        }
    }
}
