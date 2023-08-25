//
//  AppManager.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import Foundation
import Combine
import SwiftUI

struct AppManager {
    static var subscriptions = Set<AnyCancellable>()

    static let isLogin = PassthroughSubject<Bool, Never>()
    static var loginUser: UserRawData?
    
    static func isLoggedIn() -> Bool {
        return UDF.string(forKey: "idToken") != nil
    }
    
    static func logout(completion: (() -> Void)?) {
        UDF.removeObject(forKey: "idToken")
        UDF.removeObject(forKey: "userName")
        UDF.removeObject(forKey: "memId")
        UDF.removeObject(forKey: "profileImg")
        AppManager.isLogin.send(false)
        
        if let completion = completion {
            completion()
        }
    }
    
    static func removeId(id: String, completion: (() -> Void)?) {
        
        LoginApiService.removeId(id: id)
            .sink { complete in
                print("AppManager completion: \(complete)")
                switch complete {
                case .finished:
                    print("AppManager completion: finished")
                    
                case .failure(let error):
                    print("AppManager completion: failure(\(error))")
                }
            } receiveValue: { result in
                if result.resultCode == 200 {
                    completion?()
                }
            }
            .store(in: &subscriptions)
    }
}
