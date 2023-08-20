//
//  String + Ext.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/18.
//

import Foundation

extension String {
    var isEnglish: Bool {
        return self.range(of: "^[a-zA-Z]+$", options: .regularExpression) != nil
    }
    
    var isEnglishLetter: Bool {
        return self.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
}
