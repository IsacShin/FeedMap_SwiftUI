//
//  AccessGuideVM.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/09.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI
import Photos

class AccessGuideVM: NSObject, ObservableObject {
    var clManager: CLLocationManager?
    var success = CurrentValueSubject<Bool, Never>.init(false)
    
    init(clManager: CLLocationManager? = nil) {
        super.init()
        self.clManager = LocationManager.shared.clManager
        self.clManager?.delegate = self
        self.clManager?.desiredAccuracy = kCLLocationAccuracyBest
    }

}

extension AccessGuideVM: CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            break
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            print("권한 있음")
            self.clManager?.startUpdatingLocation()
            self.showCameraPermission()
        default:
            self.showCameraPermission()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        
        switch status {
        case .notDetermined:
            break
            
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            print("권한 있음")
            self.clManager?.startUpdatingLocation()
            self.showCameraPermission()
        default:
            self.showCameraPermission()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = manager.location else {
            return
        }
        
        print("위도 \(location.coordinate.latitude),경도 \(location.coordinate.longitude)")
        
//        UserManager.shared.currentLocation = CLLocation(
//            latitude: location.coordinate.latitude,
//            longitude: location.coordinate.longitude
//        )
        
        self.clManager?.stopUpdatingLocation()
    }
}

extension AccessGuideVM {
    func showCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: 권한 허용")
            } else {
                print("Camera: 권한 거부")
            }
            self.showPhotoPermission(completion: {
                DispatchQueue.main.async {
                    self.success.send(true)
                }
            })
        })
    }
    
    
    func showLocationPermission(completion: (() -> Void)? = nil ) {
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() == true else{
                completion?()
                return
            }
            
            self.clManager?.requestAlwaysAuthorization()
        }
        
    }
    
    func showPhotoPermission(completion: (() -> Void)? = nil) {
        
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in
                completion?()
            }
        } else {
            PHPhotoLibrary.requestAuthorization { _ in
                completion?()
            }
        }
    }
    
}
