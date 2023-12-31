//
//  Defines.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/09.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - SCREEN 관련
let WINDOW                  = UIApplication.getKeyWindow()
let SCREEN_WIDTH            = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT           = UIScreen.main.bounds.size.height

// MARK: - HTTP통신
let DOMAIN                  = "http://52.78.250.89:8080"
let SEARCH_KEYWORD          = "https://dapi.kakao.com/v2/local/search/keyword.json"
let KAKAO_SEARCH_KEY        = "c100792705b3b3d5dd8da673a9da10e5"

let GMAP_KEY                = "AIzaSyAFYYYgXJeT6SCOji_uSpTSP2ckkxOLLns"
let STORE_URL               = "itms-apps://itunes.apple.com/app/id6450642025"

// MARK: - UI 관련
let LIGHT_COLOR = Color.white
let DARK_COLOR = Color(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))

// MARK: - Shortcut
/// UserDefaults.standard
let UDF = UserDefaults.standard

// MARK: - Device 관련
let DEVICE                  = UIDevice.current
let APP_VER                 = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
let DEVICE_TYPE             = "IOS"
let DEVICE_MODEL            = "\(DEVICE.model)\(DEVICE.name)"
let DEVICE_ID               = UIDevice.current.identifierForVendor?.uuidString
let APP_ID                  = Bundle.main.bundleIdentifier ?? "com.isac.myreview"
let DEVICE_VERSION          = "\(DEVICE.systemVersion)"
let APP_NAME                = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""

// MARK: - ADMOB 관련
let BANNER_ADMOBKEY             = "ca-app-pub-6912457818283583/8311416199"
let FULL_SCREEN_ADMOBKEY        = "ca-app-pub-6912457818283583/7268182863"

let TEST_BANNER_ADMOBKEY        = "ca-app-pub-3940256099942544/2934735716"
let TEST_FULL_ADMOBKEY          = "ca-app-pub-3940256099942544/4411468910"
