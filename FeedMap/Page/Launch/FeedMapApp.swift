//
//  FeedMapApp.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/07.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import GoogleMaps
import GooglePlaces

@main
struct FeedMapApp: App {

    init() {
        // 설정 초기화
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GMSServices.provideAPIKey(GMAP_KEY)
        GMSPlacesClient.provideAPIKey(GMAP_KEY)
    }
    
    var body: some Scene {
        WindowGroup {
            SplashV()
        }
    }
}
