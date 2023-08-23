//
//  MapRouter.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import Foundation
import Alamofire

enum MapRouter: URLRequestConvertible {
    case getAddrGeocode(info: [String: Any])
    case getFeedList(info: [String: Any])
    
    var baseURL: URL {
        switch self {
        case .getAddrGeocode:
            return URL(string: "https://maps.googleapis.com/maps/api/geocode/json")!
        default: return URL(string: DOMAIN)!
        }
    }
    
    var endPoint: String {
        switch self {
        case .getAddrGeocode:
            return ""
        case .getFeedList:
            return "/getFeedList.do"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAddrGeocode: return .get
        case .getFeedList: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getAddrGeocode(let info):
            var params = Parameters()
            
            if let latlng = info["latlng"] as? String {
                params.updateValue(latlng, forKey: "latlng")
            }
            if let address = info["address"] as? String {
                params.updateValue(address, forKey: "address")
            }
            
            params.updateValue(GMAP_KEY, forKey: "key")
            
            return params
            
        case .getFeedList(let info):
            var params = Parameters()
            
            if let memid = info["memid"] as? String {
                params.updateValue(memid, forKey: "memid")
            }
            
            if let type = info["type"] as? String {
                params.updateValue(type, forKey: "type")
            }
            
            if let lat = info["latitude"] as? String {
                params.updateValue(lat, forKey: "latitude")
            }
            
            if let lng = info["longitude"] as? String {
                params.updateValue(lng, forKey: "longitude")
            }
            
            return params
        }
    }
    
    public var headers: HTTPHeaders {
        switch self {
        
        default:
            return HTTPHeaders(["Content-Type" : "application/json; charset=UTF-8"])
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(endPoint)
        switch self {
        case .getAddrGeocode:
            url = baseURL
        default:
            url = baseURL.appendingPathComponent(endPoint)
            
        }
        
        var request = try URLEncoding.default.encode(URLRequest(url: url), with: parameters)
        request.method = method
        request.headers = headers
//        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
       
        return request
    }
    
}
