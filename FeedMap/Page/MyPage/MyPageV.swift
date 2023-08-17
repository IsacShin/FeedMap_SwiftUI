//
//  MyPageV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/16.
//

import SwiftUI

struct MyPageV: View {
    var body: some View {
        
        NavigationView {
            VStack {
                Text("MyPage")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 54)
                    .font(.bold(size: 21))
                    .foregroundColor(.white)
                    .offset(x: 20)
                Spacer().frame(height: 20)
                ScrollView {
                    VStack(spacing: 0) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100,height: 100)
                            .aspectRatio(contentMode: .fit)
                        Spacer().frame(height: 15)
                        Text("신이삭님")
                            .font(.regular(size: 18))
                            .foregroundColor(.white)
                        Spacer().frame(height: 15)
                        Text(verbatim: "isac9305@gmail.com")
                            .padding(0)
                            .font(.regular(size: 18))
                            .foregroundColor(.white)
                        Spacer().frame(height: 10)
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.clear)
                                HStack(alignment: .center) {
                                    Text("앱 정보")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image("btnRightArrow01")
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                }
                                .frame(height: 50)
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.white)
                                HStack(alignment: .center) {
                                    Text("문의하기")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image("btnRightArrow01")
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                }
                                .frame(height: 50)
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.white)
                                HStack(alignment: .center) {
                                    Text("약관 및 정책")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image("btnRightArrow01")
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                }
                                .frame(height: 50)
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.white)
                                HStack(alignment: .center) {
                                    Text("로그아웃")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image("btnRightArrow01")
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                }
                                .frame(height: 50)
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.clear)
                            }
                            .padding([.horizontal], 20)
                            
                        }
                        .background(Color(hexString: "AAAAAA"))
                        .padding(20)
                    }
                    
                }
            }
            .background(DARK_COLOR)
        }
        
    }
}

struct MyPageV_Previews: PreviewProvider {
    static var previews: some View {
        MyPageV()
    }
}
