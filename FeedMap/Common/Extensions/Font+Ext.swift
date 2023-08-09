//
//  Font+Ext.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/09.
//

import Foundation
import SwiftUI

extension Font {
    public static func black(size: CGFloat) -> Font {
        return .custom("NotoSansCJKkr-Black", size: size)
    }
    
    public static func bold(size: CGFloat) -> Font {
        return .custom("NotoSansCJKkr-Bold", size: size)
    }
    
    public static func medium(size: CGFloat) -> Font {
        return .custom("NotoSansCJKkr-Medium", size: size)
    }
    
    public static func regular(size: CGFloat) -> Font {
        return .custom("NotoSansCJKkr-Regular", size: size)
    }
    
    public static func light(size: CGFloat) -> Font {
        return .custom("NotoSansCJKkr-Light", size: size)
    }
    
    public static func demiLight(size: CGFloat) -> Font {
        return .custom("NotoSansCJKkr-DemiLight", size: size)
    }
    
    public static func thin(size: CGFloat) -> Font {
        return Font.custom("NotoSansCJKkr-Thin", size: size)
    }
}
