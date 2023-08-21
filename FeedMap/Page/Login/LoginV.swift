//
//  LoginV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import SwiftUI

struct LoginV: View {
    @ObservedObject var vm = LoginVM()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer().frame(height: 100)
                Image("LOGO")
                    .frame(width: 150, height: 150)
                Spacer().frame(height: 20)
                Text("지도로 저장하는 나만의 피드")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                Spacer()
                
                NavigationLink {
                    idLoginV(vm: vm)
                } label: {
                    Text("로그인")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.white)
                        .padding(.horizontal, 20)
                }

                Spacer().frame(height: 10)
                
                NavigationLink {
                    JoinV()
                } label: {
                    Text("회원가입")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.white)
                        .padding(.horizontal, 20)
                }

                Spacer().frame(height: 70)
            }
            .background(DARK_COLOR)
        }
        .onReceive(AppManager.isLogin) {
            if $0 {
                presentationMode.wrappedValue.dismiss() // 이미 로그인되었으면 로그인 뷰 닫기
            }
        }
    }
}

struct LoginV_Previews: PreviewProvider {
    static var previews: some View {
        LoginV()
    }
}
