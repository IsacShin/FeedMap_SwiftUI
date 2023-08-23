//
//  LocationManager.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/09.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    var clManager = CLLocationManager()
    var currentLocation = CLLocation(latitude: 37.476284, longitude: 127.03532)

    
    private override init() {
        super.init()
        clManager.delegate = self
        clManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    deinit {
        self.clManager.stopUpdatingLocation()
    }
    
    func reqCurrentLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch self.clManager.authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse, .authorized:
                    self.clManager.startUpdatingLocation()
                default:
                    print("Not location found")
                    LocationManager.shared.currentLocation = CLLocation(
                        latitude: 37.476284,
                        longitude: 127.03532
                    )
                }
            } else {
                LocationManager.shared.currentLocation = CLLocation(
                    latitude: 37.476284,
                    longitude: 127.03532
                )
            }
        }
        
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = manager.location else {
            LocationManager.shared.currentLocation = CLLocation(
                latitude: 37.476284,
                longitude: 127.03532
            )
            return
        }
        
        print("위도 \(location.coordinate.latitude),경도 \(location.coordinate.longitude)")
        
        LocationManager.shared.currentLocation = CLLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        self.clManager.stopUpdatingLocation()
    }
}
