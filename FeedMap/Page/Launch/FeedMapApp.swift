//
//  FeedMapApp.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/07.
//

import SwiftUI
import Combine
import Firebase
import GoogleMobileAds
import GoogleMaps
import GooglePlaces

enum RootViewType {
    case Splash
    case CommonTabView
}

final class AppState : ObservableObject {
    @Published var rootViewId: RootViewType = .Splash
}

@main
struct FeedMapApp: App {
    @ObservedObject var appState = AppState()
    
    init() {
        // 설정 초기화
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GMSServices.provideAPIKey(GMAP_KEY)
        GMSPlacesClient.provideAPIKey(GMAP_KEY)
    }
    
    var body: some Scene {
        WindowGroup {
            if appState.rootViewId == .Splash {
                SplashV()
                    .id(appState.rootViewId)
                    .environmentObject(appState)
                    .dynamicTypeSize(.small)
            } else {
                CommonTabV()
                    .id(appState.rootViewId)
                    .environmentObject(appState)
                    .dynamicTypeSize(.small)
            }
        }
        
    }
}
