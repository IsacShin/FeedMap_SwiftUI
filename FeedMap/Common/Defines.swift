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
let WINDOW                  = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
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
