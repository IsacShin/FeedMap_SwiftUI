//
//  ApiLogger.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/19.
//

import Foundation
import Alamofire

final class ApiLogger: EventMonitor {
    let queue = DispatchQueue(label: "FeedMap_ApiLogger")
    
    func requestDidResume(_ request: Request) {
        print("ApiLogger-Resuming: \(request)")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        if let error = response.error {
            switch error {
            case .sessionTaskFailed(let error):
                print("ApiLogger 에러 - error: ", error)
                if error._code == NSURLErrorTimedOut {
                    print("[API 타임아웃] Time out occurs!!!")
                    NotificationCenter.default.post(name: .requestTimeout, object: nil)
                    
                }
            default: print("default")
            }
        }
        debugPrint("ApiLogger-Finished: \(response)")
    }
}
