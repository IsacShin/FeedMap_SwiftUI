//
//  LabelTextField.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/20.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct FloatingLabelTF: ViewModifier {
    @Binding var text: String
    var placeholder: String
    var isSecurity: Bool
    var defaultType: Bool
    
    func body(content: Content) -> some View {
        FloatingLabelTextField($text, placeholder: placeholder)
            .titleColor(.white)
            .selectedLineColor(.white)
            .selectedTextColor(.white)
            .selectedTitleColor(.white)
            .lineColor(.white)
            .placeholderColor(.white)
            .placeholderFont(.system(size: 17))
            .titleFont(.system(size: 17))
            .textColor(.gray)
            .isSecureTextEntry(isSecurity)
            .keyboardType(defaultType ? .default : .alphabet)
            .frame(height: 60)
            .padding(.horizontal, 20)
    }
}

extension View {
    func floatingLabelTextFieldStyle(text: Binding<String>, placeholder: String, isSecurity: Bool = false, defaultType: Bool = false) -> some View {
        self.modifier(FloatingLabelTF(text: text, placeholder: placeholder, isSecurity: isSecurity, defaultType: defaultType))
    }
}

struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        FloatingLabelTextField(.constant("테스트"))
            .titleColor(.white)
            .selectedLineColor(.white)
            .selectedTextColor(.white)
            .selectedTitleColor(.white)
            .lineColor(.white)
            .placeholderColor(.white)
            .placeholderFont(.system(size: 17))
            .titleFont(.system(size: 17))
            .textColor(.gray)
            .isSecureTextEntry(true)
            .frame(height: 60)
            .padding(.horizontal, 20)
    }
}
