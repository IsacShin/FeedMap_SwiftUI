//
//  TermsV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import SwiftUI

struct TermsV: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    
    var body: some View {
        VStack {
            NavigationLink {
                let url = DOMAIN + "/terms.do"
                CommonWebV(urlStr: url)
            } label: {
                HStack(alignment: .center) {
                    Text("개인정보 처리방침")
                        .foregroundColor(.white)
                    Spacer()
                    Image("btnRightArrow01")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                }
                .frame(height: 50)
            }

            Divider()
                .frame(height: 1)
                .background(Color.white)
            
            NavigationLink {
                let url = DOMAIN + "/locationTerms.do"
                CommonWebV(urlStr: url)
            } label: {
                HStack(alignment: .center) {
                    Text("위치기반서비스 이용약관")
                        .foregroundColor(.white)
                    Spacer()
                    Image("btnRightArrow01")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                }
                .frame(height: 50)
            }
            
            Divider()
                .frame(height: 1)
                .background(Color.white)
            
            NavigationLink {
                let url = DOMAIN + "/serviceTerms.do"
                CommonWebV(urlStr: url)
            } label: {
                HStack(alignment: .center) {
                    Text("서비스 이용약관")
                        .foregroundColor(.white)
                    Spacer()
                    Image("btnRightArrow01")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                }
                .frame(height: 50)
            }
            
            Divider()
                .frame(height: 1)
                .background(Color.clear)
            Spacer()
        }
        .padding(20)
        .background(DARK_COLOR)
        .navigationTitle("약관 및 정책")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsV_Previews: PreviewProvider {
    static var previews: some View {
        TermsV()
    }
}
