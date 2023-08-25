//
//  FeedRouter.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/23.
//

import Foundation
import Alamofire
import UIKit

enum FeedRouter: URLRequestConvertible {
    case fileUpload([UIImage])
    case insertFeed([String: Any])
    case updateFeed([String: Any])
    case removeFeed([String: Any])
    case insertReport([String: Any])
    
    var baseURL: URL {
        return URL(string: DOMAIN)!
    }
    
    var endPoint: String {
        switch self {
        case .fileUpload:
            return "/upload2.do"
        case .insertFeed:
            return "/insertFeed.do"
        case .updateFeed:
            return "/updateFeed.do"
        case .removeFeed:
            return "/removeFeed.do"
        case .insertReport:
            return "/insertReport.do"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fileUpload: return .post
        default: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .fileUpload:
            return Parameters()
        case .insertFeed(let info):
            var params = Parameters()
            if let title = info["title"] as? String {
                params.updateValue(title, forKey: "title")
            }
            if let addr = info["addr"] as? String {
                params.updateValue(addr, forKey: "addr")
            }
            if let comment = info["comment"] as? String {
                params.updateValue(comment, forKey: "comment")
            }
            if let img1 = info["img1"] as? String {
                params.updateValue(img1, forKey: "img1")
            }
            
            if let img2 = info["img2"] as? String {
                params.updateValue(img2, forKey: "img2")
            }
            
            if let img3 = info["img3"] as? String {
                params.updateValue(img3, forKey: "img3")
            }
            
            if let lat = info["latitude"] as? String {
                params.updateValue(lat, forKey: "latitude")
            }
            
            if let lng = info["longitude"] as? String {
                params.updateValue(lng, forKey: "longitude")
            }
            
            if let memId = info["memid"] as? String {
                params.updateValue(memId, forKey: "memid")
            }
            
            return params
        case .updateFeed(let info):
            var params = Parameters()
            if let title = info["title"] as? String {
                params.updateValue(title, forKey: "title")
            }
            if let addr = info["addr"] as? String {
                params.updateValue(addr, forKey: "addr")
            }
            if let comment = info["comment"] as? String {
                params.updateValue(comment, forKey: "comment")
            }
            if let img1 = info["img1"] as? String {
                params.updateValue(img1, forKey: "img1")
            }
            
            if let img2 = info["img2"] as? String {
                params.updateValue(img2, forKey: "img2")
            }
            
            if let img3 = info["img3"] as? String {
                params.updateValue(img3, forKey: "img3")
            }
            
            if let id = info["id"] as? Int {
                params.updateValue(id, forKey: "id")
            }
            
            if let lat = info["latitude"] as? String {
                params.updateValue(lat, forKey: "latitude")
            }
            
            if let lng = info["longitude"] as? String {
                params.updateValue(lng, forKey: "longitude")
            }
            
            if let memId = info["memid"] as? String {
                params.updateValue(memId, forKey: "memid")
            }
            
            
            return params
        case .removeFeed(let info):
            var params = Parameters()
            if let memId = info["memid"] as? String {
                params.updateValue(memId, forKey: "memid")
            }
            if let id = info["id"] as? Int {
                params.updateValue(id, forKey: "id")
            }
            return params
            
        case .insertReport(let info):
            var params = Parameters()
            if let memId = info["reporter"] as? String {
                params.updateValue(memId, forKey: "reporter")
            }
            if let id = info["feedid"] as? Int {
                params.updateValue(id, forKey: "feedid")
            }
            if let reason = info["reason"] as? String {
                params.updateValue(reason, forKey: "reason")
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
            for (index, img) in uploadImg.enumerated() {
                guard let fileData = img.jpegData(compressionQuality: 0.1) else { return multipartFormData }
                multipartFormData.append(fileData,
                           withName: "file\(index)",
                           fileName: "file\(index).jpeg",
                           mimeType: "image/jpeg")
            }
        default: ()
        }
        
        return multipartFormData
    }
}
