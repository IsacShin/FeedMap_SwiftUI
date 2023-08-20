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

final class AppVM: ObservableObject {
    @Published var rootViewId: RootViewType = .Splash
}

@main
struct FeedMapApp: App {
    @ObservedObject var vm = AppVM()
    
    init() {
        // 설정 초기화
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GMSServices.provideAPIKey(GMAP_KEY)
        GMSPlacesClient.provideAPIKey(GMAP_KEY)
    }
    
    var body: some Scene {
        WindowGroup {
            if vm.rootViewId == .Splash {
                SplashV()
                    .id(vm.rootViewId)
                    .environmentObject(vm)
                    .dynamicTypeSize(.small)
            } else {
                CommonTabV()
                    .id(vm.rootViewId)
                    .environmentObject(vm)
                    .dynamicTypeSize(.small)
            }
        }
        
    }
}
