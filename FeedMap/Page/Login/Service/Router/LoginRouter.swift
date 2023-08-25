//
//  LoginRouter.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/19.
//

import Foundation
import Alamofire

enum LoginRouter: URLRequestConvertible {
    case idLogin(id: String, password: String)
    case removeId(id: String)
    
    var baseURL: URL {
        return URL(string: DOMAIN)!
    }
    
    var endPoint: String {
        switch self {
        case .idLogin:
            return "/getMember.do"
        case .removeId:
            return "/removeMember.do"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .idLogin: return .get
        case .removeId: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .idLogin(let id, let password):
            var params = Parameters()
            params.updateValue(id, forKey: "memid")
            params.updateValue(password, forKey: "password")
            
            return params
            
        case .removeId(let id):
            var params = Parameters()
            params.updateValue(id, forKey: "memid")
            
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = try URLEncoding.default.encode(URLRequest(url: url), with: parameters)
        request.method = method
//        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
       
        return request
    }
}

