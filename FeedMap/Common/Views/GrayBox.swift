//
//  GrayBox.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/09.
//

import SwiftUI
import Hex

struct GrayBox: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(hexString: "f7f7f7"))
            .cornerRadius(16)
    }
}

struct GrayBox_Previews: PreviewProvider {
    static var previews: some View {
        Text("ddfdsafsdafsdfsad")
            .modifier(GrayBox())
    }
}
