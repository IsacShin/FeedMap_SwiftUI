//
//  JoinRouter.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/21.
//

import Foundation
import Alamofire
import UIKit

enum JoinRouter: URLRequestConvertible {
    case fileUpload(UIImage)
    case insertMember([String: Any])
    case getMemberId([String: Any])
    
    var baseURL: URL {
        return URL(string: DOMAIN)!
    }
    
    var endPoint: String {
        switch self {
        case .fileUpload:
            return "/upload2.do"
        case .insertMember:
            return "/insertMember.do"
        case .getMemberId:
            return "/getMemberId.do"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fileUpload: return .post
        case .insertMember: return .get
        case .getMemberId: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .fileUpload:
            return Parameters()
        case .insertMember(let info):
            var params = Parameters()
            if let memId = info["memId"] as? String {
                params.updateValue(memId, forKey: "memid")
            }
            if let name = info["name"] as? String {
                params.updateValue(name.replacingOccurrences(of: "[^a-zA-Z0-9가-힣\\s]", with: "", options: .regularExpression) as Any, forKey: "name")
            }
            if let password = info["password"] as? String {
                params.updateValue(password, forKey: "password")
            }
            if let profileUrl = info["profileUrl"] as? String {
                params.updateValue(profileUrl, forKey: "profileUrl")
            }
            
            return params
        case .getMemberId(let info):
            var params = Parameters()
            if let memId = info["memId"] as? String {
                params.updateValue(memId, forKey: "memid")
            }
            if let name = info["name"] as? String {
                params.updateValue(name.replacingOccurrences(of: "[^a-zA-Z0-9가-힣\\s]", with: "", options: .regularExpression) as Any, forKey: "name")
            }
            if let password = info["password"] as? String {
                params.updateValue(password, forKey: "password")
            }
            if let profileUrl = info["profileUrl"] as? String {
                params.updateValue(profileUrl, forKey: "profileUrl")
            }
            
            return params
        }
    }
    
    public var headers: HTTPHeaders {
        switch self {
        case .fileUpload:
            return HTTPHeaders(["Content-Type" : "multipart/form-data"])
            
        default:
            return HTTPHeaders(["Content-Type" : "application/json; charset=UTF-8"])
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        
        switch self {
        case .fileUpload:
            var request = URLRequest(url: url)
            request.method = method
            request.headers = headers
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody

            return request
        default:
            var request = try URLEncoding.default.encode(URLRequest(url: url), with: parameters)
            request.method = method
            request.headers = headers
            return request
        }
        
    }
    
    var multipartFormData: MultipartFormData {
        let multipartFormData = MultipartFormData()
        switch self {
        case .fileUpload(let uploadImg):
            guard let fileData = uploadImg.jpegData(compressionQuality: 0.1) else { return multipartFormData }
            multipartFormData.append(fileData,
                       withName: "file0",
                       fileName: "file0.jpeg",
                       mimeType: "image/jpeg")
        default: ()
        }
        
        return multipartFormData
    }
}
