//
//  JoinV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/20.
//

import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct JoinV: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .darkGray
    }
    
    @State private var profileImg: UIImage?
    @State private var name: String = ""
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var passwordCheck: String = ""
    @State private var isValid: Bool = false
    @State var keyboardStatus: KeyboardManager.Status = .hide
    @State var showAlert = false
    @State private var alertType: AlertType = .isJoinFailed
    @State var isTermCheck: Bool = false
    @State var showPhotoPicker: Bool = false

    @State var placeholder = "비밀번호 확인"
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var keyboardManager = KeyboardManager()
    @ObservedObject var vm: JoinVM = JoinVM()

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer()
                    
                    Group {
                        Spacer().frame(height: 30)
                        Button {
                            self.showPhotoPicker = true
                        } label: {
                            if let img = self.profileImg {
                                Image(uiImage: img)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        Circle().stroke(Color.white, lineWidth: 3)
                                    }
                                    .overlay {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .tint(.white)
                                    }
                            } else {
                                Image("")
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        Circle().stroke(Color.white, lineWidth: 3)
                                    }
                                    .overlay {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .tint(.white)
                                    }
                            }
                            
                        }

                        Spacer().frame(height: 30)
                        Text("프로필 이미지를 등록해주세요")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Group {
                        FloatingLabelTextField($name, placeholder: "이름")
                            .floatingLabelTextFieldStyle(text: $name, placeholder: "이름", defaultType: true)
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
                            .onChange(of: name, perform: { newValue in
                                if name.count > 10  {
                                    name = String(newValue.prefix(10))
                                } else {
                                    if newValue.count > 1 {
                                        self.vm.nameCheck.send(true)
                                    } else {
                                        self.vm.nameCheck.send(false)
                                    }
                                }
                            })
                        
                        Spacer().frame(height: 12)
                    }
                    
                    Group {
                        FloatingLabelTextField($id, placeholder: "아이디")
                            .floatingLabelTextFieldStyle(text: $id, placeholder: "아이디")
                            
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
                    }
                    
                    Group {
                        FloatingLabelTextField($password, placeholder: "비밀번호")
                            .floatingLabelTextFieldStyle(text: $password, placeholder: "비밀번호", isSecurity: true)
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
                        
                        Spacer().frame(height: 12)
                    }
                    
                    Group {
                        FloatingLabelTextField($passwordCheck, placeholder: placeholder)
                            .titleColor(.white)
                            .selectedLineColor(.white)
                            .selectedTextColor(.white)
                            .selectedTitleColor(.white)
                            .lineColor(.white)
                            .placeholderColor(placeholder == "비밀번호 확인" ? .white : .red)
                            .placeholderFont(.system(size: 17))
                            .titleFont(.system(size: 17))
                            .textColor(.gray)
                            .isSecureTextEntry(true)
                            .keyboardType(.alphabet)
                            .frame(height: 60)
                            .padding(.horizontal, 20)
                            .onChange(of: passwordCheck, perform: { newValue in
                                if newValue != password {
                                    self.vm.pwdConfirmCheck.send(false)
                                    self.placeholder = "비밀번호를 확인해주세요."
                                } else {
                                    self.vm.pwdConfirmCheck.send(true)
                                    self.placeholder = "비밀번호 확인"
                                }
                            })
                        
                        Spacer().frame(height: 12)
                    }
                      
                    HStack {
                        Button {
                            self.isTermCheck = true
                            self.vm.termCheck.send(self.isTermCheck)
                        } label: {
                            Image(isTermCheck ? "chkOn" : "chkOff")
                                .frame(width: 35, height: 35)
                            Spacer().frame(width: 5)
                            Text("서비스 이용약관 동의")
                                .font(.regular(size: 14))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        NavigationLink {
                            let url = DOMAIN + "/terms.do"
                            CommonWebV(urlStr: url)
                        } label: {
                            Text("자세히보기")
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()

                    Button {
                        let info = [
                            "memId" : self.id,
                            "name" : self.name,
                            "password" : self.password
                        ]
                        self.vm.regist(fileImg: self.profileImg,
                                       info: info) {
                            self.vm.isSuccess = true
                        }
                        
                    } label: {
                        Text("회원가입")
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .font(.medium(size: 16))
                            .foregroundColor(.white)
                            .background(isValid ? .black : .gray)
                            .cornerRadius(16)
                            .padding(20)

                    }
                    .disabled(!isValid)
                    
                }
                
                .background(DARK_COLOR)
                .frame(minHeight: geometry.size.height)
            }
            .background(DARK_COLOR)
            .onReceive(self.keyboardManager.updateKeyboardStatus) { updatedStatus in
                self.keyboardStatus = updatedStatus
                print("높이: \(keyboardManager.keyboardHeight)")
            }
            .onReceive(vm.$isJoinFailed) { isJoinFailed in
                self.alertType = .isJoinFailed
                self.showAlert = isJoinFailed
            }
            .onReceive(vm.$isJoinedAlert) { isJoinedAlert in
                self.alertType = .isJoinedAlert
                self.showAlert = isJoinedAlert
            }
            .onReceive(vm.$isSuccess) { isSuccess in
                self.alertType = .joinSuccess
                self.showAlert = isSuccess
            }
            .onTapGesture {
                self.endEditing(true)
            }
            .alert(isPresented: self.$showAlert) {
                var msg: String = ""
                
                if self.alertType == .joinSuccess {
                    msg = "가입되었습니다."
                } else if self.alertType == .isJoinedAlert {
                    msg = "이미 가입한 사용자 입니다."
                } else if self.alertType == .isJoinFailed {
                    msg = "문제가 발생하였습니다.\n다시 시도해주세요."
                }
                return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
                    NaviManager.popToRootView()
                }))
            }
            .sheet(isPresented: $showPhotoPicker) {
                CommonImagePicker(completion: { images in
                    guard let profileImg = images.first else { return }
                    self.profileImg = profileImg
                }, maxCount: 1)
            }
            
            .navigationTitle("회원가입")
        }
        .background(DARK_COLOR)
        .onAppear {
            vm.isValidCheck1Publisher
                .combineLatest(vm.isValidCheck2Publisher)
                .eraseToAnyPublisher()
                .sink {
                    if $0.0.0 &&
                        $0.0.1 &&
                        $0.0.2 &&
                        $0.1.0 &&
                        $0.1.1 {
                        self.isValid = true
                    } else {
                        self.isValid = false
                    }
                }
                .store(in: &vm.subscriptions)

        }
        
    }
}

struct JoinV_Previews: PreviewProvider {
    static var previews: some View {
        JoinV()
    }
}
