//
//  ApiClient.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/19.
//

import Foundation
import Alamofire

final class ApiClient {
    static let shared = ApiClient()
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    
    var session: Session
    
    init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
