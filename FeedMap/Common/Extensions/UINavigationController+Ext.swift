//
//  UINavigationController+Ext.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import Foundation
import UIKit

extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationBar.topItem?.backBarButtonItem?.tintColor = .white
    }
    
}
