//
//  MyPageV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/16.
//

import SwiftUI

struct MyPageV: View {
    
    @EnvironmentObject var appVM: AppVM
    @State var isVersionAlert: Bool = false
    @State var isQnAAlert: Bool = false
    @State var isLogoutAlert: Bool = false
    @Binding var selectTab: TabType
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
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
                        Spacer().frame(height: 10)
                        Text("신이삭님")
                            .font(.regular(size: 18))
                            .foregroundColor(.white)
                        Spacer().frame(height: 10)
                        Text(verbatim: "isac9305@gmail.com")
                            .padding(0)
                            .font(.regular(size: 18))
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 0) {
                            VStack(alignment: .leading, spacing: 0) {
                               
                                Spacer().frame(height: 10)
                                Button {
                                    self.isVersionAlert.toggle()
                                } label: {
                                    // 앱정보
                                    HStack(alignment: .center) {
                                        Text("앱 정보")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image("btnRightArrow01")
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                    }
                                    .frame(height: 52)
                                }
                                .alert(isPresented: $isVersionAlert) {
                                    Alert(title: Text("현재 버전은 \(APP_VER) 입니다"), dismissButton: .default(Text("확인"), action: {
                                        print("버튼 클릭")
                                    }))
                                }

                                Divider()
                                    .frame(height: 1)
                                    .background(Color.white)
                                
                                Button {
                                    self.isQnAAlert.toggle()
                                } label: {
                                    // 문의하기
                                    HStack(alignment: .center) {
                                        Text("문의하기")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image("btnRightArrow01")
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                    }
                                    .frame(height: 52)
                                }
                                .alert(isPresented: $isQnAAlert) {
                                    Alert(title: Text("아래 이메일로 문의주세요."), message: Text("isac9305@gmail.com"), dismissButton: .default(Text("확인"), action: {
                                        print("버튼 클릭")
                                    }))
                                }
                                

                                Divider()
                                    .frame(height: 1)
                                    .background(Color.white)
                                
                                NavigationLink {
                                    TermsV()
                                } label: {
                                    // 약관 및 정책
                                    HStack(alignment: .center) {
                                        Text("약관 및 정책")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image("btnRightArrow01")
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                    }
                                    .frame(height: 52)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.white)
                                
                                Button {
                                    self.isLogoutAlert.toggle()
                                } label: {
                                    // 로그아웃
                                    HStack(alignment: .center) {
                                        Text("로그아웃")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image("btnRightArrow01")
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                    }
                                    .frame(height: 52)
                                }
                                .alert(isPresented: $isLogoutAlert) {
                                    Alert(title: Text("로그아웃 하시겠습니까?"), primaryButton: .default(Text("확인"), action: {
                                        AppManager.logout {
                                            self.selectTab = .MAP
                                            DispatchQueue.main.async {
                                                NaviManager.popToRootView {
                                                    appVM.rootViewId = .CommonTabView
                                                }
                                            }
                                        }
                                    }), secondaryButton: .cancel(Text("취소")))
                                }
                                Spacer().frame(height: 10)
               
                            }
                            .padding([.horizontal], 20)
                            
                        }
                        .background(Color(hexString: "AAAAAA"))
                        .cornerRadius(16)
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
        MyPageV(selectTab: .constant(.MYPAGE))
    }
}
