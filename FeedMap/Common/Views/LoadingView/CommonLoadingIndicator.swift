//
//  CommonLoadingV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import UIKit
import SwiftUI

struct CommonLoadingIndicator: UIViewRepresentable {
    var isAnim = true
    var color: UIColor = .white
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnim ? uiView.startAnimating() : uiView.stopAnimating()
        uiView.style = .large
        uiView.color = color
    }
}

