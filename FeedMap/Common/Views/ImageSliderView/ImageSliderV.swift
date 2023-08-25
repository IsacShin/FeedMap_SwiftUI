//
//  ImageSliderV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/25.
//

import SwiftUI
import Kingfisher

struct ImageSliderV: View {
    @Binding var images: [String]
    @GestureState private var zoom = 1.0
    
    var body: some View {
        GeometryReader { p in
            TabView {
                ForEach(images, id: \.self) { item in
                    if let url = URL(string: item) {
                        KFImage(url)
                            .placeholder {
                                Rectangle()
                                    .background(.gray)
                            }
                            .resizable()
                            .scaledToFill()
                            .modifier(ImageModifier(contentSize: CGSize(width: p.size.width, height: p.size.height)))
                    }
                    
                   
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
        
    }
}

struct ImageSliderV_Previews: PreviewProvider {
    static var previews: some View {
        ImageSliderV(images: .constant([
        "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80",
        "https://png.pngtree.com/thumb_back/fh260/png-vector/20200530/ourmid/pngtree-beach-png-image_2215226.jpg",
        "https://img.freepik.com/premium-photo/lights-on-sea-background-waves_196038-1983.jpg"
        ]))
    }
}
