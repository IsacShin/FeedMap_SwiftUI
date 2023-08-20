//
//  idLoginV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/18.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct idLoginV: View {
    
    init(vm: LoginVM) {
        self.vm = vm
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var isValid: Bool = false
    @State var keyboardStatus: KeyboardManager.Status = .hide
    @State var isLoginFailed: Bool = false
    
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var keyboardManager = KeyboardManager()
    @ObservedObject var vm: LoginVM

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer()
                    FloatingLabelTextField($id, placeholder: "아이디")
                    .titleColor(.white)
                    .selectedLineColor(.white)
                    .selectedTextColor(.white)
                    .selectedTitleColor(.white)
                    .lineColor(.white)
                    .placeholderColor(.white)
                    .placeholderFont(.system(size: 17))
                    .titleFont(.system(size: 17))
                    .textColor(.gray)
                    .keyboardType(.alphabet)
                    .frame(height: 60)
                    .padding(.horizontal, 20)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button {
                                self.endEditing(true)
                            } label: {
                                Text("닫기")
                                    .font(.bold(size: 17))
                            }
                            Spacer()
                        }
                    }
                    .onChange(of: id, perform: { newValue in
                        if id.count > 20  {
                            id = String(newValue.prefix(20))
                        } else {
                            if newValue.count > 3 {
                                self.vm.idCheck.send(true)
                            } else {
                                self.vm.idCheck.send(false)
                            }
                        }
                    })
                    
                    Spacer().frame(height: 12)
                    
                    FloatingLabelTextField($password, placeholder: "비밀번호", editingChanged: { (isChanged) in
                        
                    }) {
                        print(password)
                    }
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
                    .onChange(of: password, perform: { newValue in
                        if password.count > 20  {
                            password = String(newValue.prefix(20))
                        } else {
                            if newValue.count > 3 {
                                self.vm.pwdCheck.send(true)
                            } else {
                                self.vm.pwdCheck.send(false)
                            }
                        }
                    })
                    
                    Button {
                        self.vm.idLogin(id: id, password: password) {
                            NaviManager.popToRootView {
                                withAnimation {
                                    appVM.rootViewId = .CommonTabView
                                }
                            }
                        }
                    } label: {
                        Text("로그인")
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .font(.medium(size: 16))
                            .foregroundColor(.white)
                            .background(isValid ? .black : .gray)
                            .cornerRadius(16)
                            .padding(20)

                    }
                    .disabled(!isValid)
                    
                    Spacer()
                }
                .background(DARK_COLOR)
                .frame(minHeight: geometry.size.height)
            }
            .background(DARK_COLOR)
            .onReceive(self.keyboardManager.updateKeyboardStatus) { updatedStatus in
                self.keyboardStatus = updatedStatus
                print("높이: \(keyboardManager.keyboardHeight)")
            }
            .onReceive(vm.$isLoginFailed) { isLoginFailed in
                self.isLoginFailed = isLoginFailed
            }
            .onTapGesture {
                self.endEditing(true)
            }
            .alert(isPresented: self.$isLoginFailed) {
                Alert(title: Text("아이디 또는 비밀번호를 확인해주세요."), dismissButton: .default(Text("확인"), action: {
                    print("버튼 클릭")
                }))
            }
            
            .navigationTitle("로그인")
        }
        .background(DARK_COLOR)
        .onAppear {
            vm.isValidPublisher
                .sink { value1, value2 in
                    print("Combined Values: \(value1), \(value2)")
                    if value1 && value2 {
                        isValid = true
                    } else {
                        isValid = false
                    }
                }
                .store(in: &vm.subscriptions)
        }
        
    }
}

struct idLoginV_Previews: PreviewProvider {
    static var previews: some View {
        idLoginV(vm: LoginVM())
    }
}
