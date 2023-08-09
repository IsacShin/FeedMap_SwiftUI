//
//  SplashVM.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/09.
//

import Foundation
import Combine

enum LaunchState {
    case firstLaunch, yetLaunch
}

class SplashVM: ObservableObject {
    var nextAction = PassthroughSubject<LaunchState, Never>()
    
    func startLaunch() {
        if UDF.bool(forKey: "firstLaunch") {
            self.nextAction.send(.yetLaunch)
        } else {
            self.nextAction.send(.firstLaunch)
        }
    }
}
