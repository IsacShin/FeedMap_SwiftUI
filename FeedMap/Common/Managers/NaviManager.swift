//
//  NaviManager.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/16.
//

import Foundation
import SwiftUI

struct NaviManager {
    static func popToRootView(completion: (() -> Void)? = nil) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        findNavigationController(viewController: keyWindow?.rootViewController)?
            .popToRootViewController(animated: true)
        CATransaction.commit()
        
    }
    
    static func popViewController(handler: () -> Void ,completion: @escaping () -> Void) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        handler()
        
        CATransaction.commit()
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}
