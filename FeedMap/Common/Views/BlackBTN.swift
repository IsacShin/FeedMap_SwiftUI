//
//  BlackBTN.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/09.
//

import Foundation
import SwiftUI

struct BlackBTN: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .font(.medium(size: 16))
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(16)
            .padding(20)
    }
}

struct BlackBTN_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            print("clicked")
        } label: {
            Text("호호")
        }.buttonStyle(BlackBTN())
    }
}
