//
//  MapVM.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import Foundation
import SwiftUI
import Combine
import Alamofire
import CoreLocation

class MapVM: NSObject, ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    var isCheckCurrentLocationFail = PassthroughSubject<Bool, Never>()
    var currentLocation = PassthroughSubject<CLLocation?, Never>()
    var moveLocation = PassthroughSubject<CLLocation?, Never>()
    var feedListRawData = PassthroughSubject<[FeedRawData]?, Never>()
    var selectFeedRawData = PassthroughSubject<FeedRawData?, Never>()
    
    @Published var isSelectTab = false
    @Published var isFeedCheck = false
    @Published var centerLocation: CLLocation?
    @Published var centerAddr: String?
    @Published var isUpdateCheck = false
   
    private var clManager: CLLocationManager? = LocationManager.shared.clManager
    private var currentHandler: (() -> Void)?
    
    override init() {
        super.init()
        
        let notiCenter = NotificationCenter.default.publisher(for: Notification.Name("addrInfo"))
        
        notiCenter
            .sink { noti in
                guard let userInfo = noti.userInfo,
                      let jibunAddress = userInfo["jibunAddress"] as? String,
                      let roadAddress = userInfo["roadAddress"] as? String,
                      let zonecode = userInfo["zonecode"] as? String else { return }
                
                let param = [
                    "address" : jibunAddress,
                    "key" : GMAP_KEY
                ]
                
                self.getAddrGeocode(param: param)
            }
            .store(in: &subscriptions)
        
        
    }
   
    func getAddrGeocode(param: [String: Any]) {
        MapApiService.getAddrGeocode(info: param)
            .sink { complete in
                print("MapVM completion: \(complete)")
                switch complete {
                case .finished:
                    print("MapVM completion: finished")
                case .failure(let error):
                    print("MapVM completion: failure(\(error))")
                }
            } receiveValue: { result in
                guard let location = result.results?.first?.geometry?.location else { return }
                guard let lat = location.lat,
                      let lng = location.lng else { return }
                
                if let formatted_address = result.results?.first?.formatted_address {
                    self.centerAddr = formatted_address
                }
                        
                let loca = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
                self.moveLocation.send(loca)
            }
            .store(in: &subscriptions)
    }
    
    func getFeedList(_ check:Bool? = false, loca: CLLocation?, completion: (() -> Void)?) {
        guard let memId = UDF.string(forKey: "memId") else { return }
        var param: [String:Any] = [
            "memid" : memId,
            "type" : "my"
        ]
        
        if let loca = loca {
            let lat = String(format: "%.4f", Double(loca.coordinate.latitude))
            let lng = String(format: "%.4f", Double(loca.coordinate.longitude))
            param.updateValue(lat, forKey: "latitude")
            param.updateValue(lng, forKey: "longitude")
        }
        
        MapApiService.getFeedList(info: param)
            .sink { complete in
                print("MapVM completion: \(complete)")
                switch complete {
                case .finished:
                    print("MapVM completion: finished")
                    completion?()
                case .failure(let error):
                    print("MapVM completion: failure(\(error))")
                }
            } receiveValue: { result in
                if check == true {
                    if let cData = result.list?.first {
                        self.isFeedCheck = false
                    } else {
                        self.isFeedCheck = true
                    }
                } else {
                    self.feedListRawData.send(result.list)
                }
            }
            .store(in: &subscriptions)
    }
    
    // 현재 위치 권한 검사
    func checkCurrentLocationAuth(_ completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch self.clManager?.authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    self.currentHandler = completion
                    // Location services are enabled
                    self.clManager?.delegate = self
                    self.clManager?.desiredAccuracy = kCLLocationAccuracyBest
                    self.clManager?.requestAlwaysAuthorization()
                    self.clManager?.startUpdatingLocation()
                default:
                    print("Not location found")
                    self.isCheckCurrentLocationFail.send(true)
                }
            } else {
                self.isCheckCurrentLocationFail.send(true)
            }
        }
    }
}

extension MapVM: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            return
        }
        
        manager.stopUpdatingLocation()
        
        LocationManager.shared.currentLocation = CLLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        self.currentLocation.send(LocationManager.shared.currentLocation)

        if let handler = self.currentHandler {
            handler()
        }

    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        self.locationManagerStatus(status: manager.authorizationStatus)
    }
    
    
    @available(*, deprecated)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        self.locationManagerStatus(status: status)
    }
    
    private func locationManagerStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted:
            print("미정")
        case .denied:
            self.isCheckCurrentLocationFail.send(true)
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            print("권한 있음")
            self.clManager?.startUpdatingLocation()
            self.isCheckCurrentLocationFail.send(false)
        @unknown default:
            self.isCheckCurrentLocationFail.send(true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        self.error.accept(error)
    }
}
