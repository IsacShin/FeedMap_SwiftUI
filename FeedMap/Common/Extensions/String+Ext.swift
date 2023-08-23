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
    
    // 년,월,일
    func wddSimpleDateForm() -> String? {
        let dateString = self

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = inputFormatter.date(from: dateString) {
            let formattedDate = outputFormatter.string(from: date)
            print(formattedDate) // 출력: 2023-06-23 23:04:18
            return formattedDate
        } else {
            print("날짜 변환 실패")
            return nil
        }
    }
}
