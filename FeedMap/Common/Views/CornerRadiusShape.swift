//
//  CornerRadiusShape.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import Foundation
import SwiftUI

struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
