//
//  SelectTabV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import SwiftUI
import Kingfisher
import CoreLocation

struct SelectTabV: View {
    
    @Binding var selectFeedData: FeedRawData?
    
    var body: some View {
        
        if let selectFeedData = self.selectFeedData {
            GeometryReader { g in
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        Spacer().frame(height: 8)
                        Text(selectFeedData.date?.wddSimpleDateForm() ?? "")
                            .foregroundColor(.white)
                            .font(.regular(size: 12))
                        Text(selectFeedData.addr ?? "")
                            .foregroundColor(.white)
                            .font(.regular(size: 15))
                        
                        if let lat = selectFeedData.latitude,
                           let lng = selectFeedData.longitude,
                           let dLat = Double(lat),
                           let dLng = Double(lng) {
                            let loca = CLLocation(latitude: dLat, longitude: dLng)
                            NavigationLink {
                                
                                FeedWriteV(isUpdateV: true,
                                           loca: loca,
                                           address: selectFeedData.addr,
                                           selectFeedData: selectFeedData)
                            } label: {
                                if let url = URL(string: selectFeedData.img1 ?? "") {
                                    KFImage(url)
                                        .placeholder {
                                            Image(systemName: "person.circle.fill")
                                        }
                                        .resizable()
                                        .frame(width: g.size.width - 40, height: 200)
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(16)
                                }
                            }
                        }
                        
                        

                        Text(selectFeedData.title ?? "")
                            .foregroundColor(.white)
                            .font(.bold(size: 17))
                        Text(selectFeedData.comment ?? "")
                            .foregroundColor(.white)
                            .font(.regular(size: 15))
                        Spacer().frame(height: 8)
                    }
                    .padding(.horizontal, 20)
                    .background(DARK_COLOR).opacity(0.9)
                    .cornerRadius(radius: 16.0, corners: [.topLeft, .topRight])
                }
                
            }
        }
        
    }
}

struct SelectTabV_Previews: PreviewProvider {
    static var previews: some View {
        SelectTabV(selectFeedData: .constant(nil))
    }
}
