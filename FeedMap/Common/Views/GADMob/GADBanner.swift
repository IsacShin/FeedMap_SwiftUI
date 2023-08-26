//
//  GADBanner.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/26.
//

import Foundation
import UIKit
import GoogleMobileAds
import SwiftUI

struct GADBanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        #if DEBUG
        view.adUnitID = TEST_BANNER_ADMOBKEY // test Key
        #endif
        #if RELEASE
        view.adUnitID = BANNER_ADMOBKEY 
        #endif
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}
