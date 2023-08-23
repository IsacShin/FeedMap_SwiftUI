//
//  FeedWriteV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import SwiftUI
import CoreLocation

struct FeedWriteV: View {
    
    init(isUpdateV: Bool, loca: CLLocation?, address: String?, selectFeedData: FeedRawData? = nil) {
        self.isUpdateV = isUpdateV
        self.selectFeedData = selectFeedData
        self.address = address
        self.loca = loca
    }
    
    @State var addr: String = ""
    @State var title: String = ""
    @State var comment: String = ""
    @State var keyboardStatus: KeyboardManager.Status = .hide

    @State var imgs: [UIImage] = []
    @State private var alertType: AlertType = .feedTitleNotExists
    @State var showAlert = false
    @State var showPhotoPicker: Bool = false
    @State var isLoading: Bool = false

    @ObservedObject var keyboardManager = KeyboardManager()
    @ObservedObject var vm = FeedWriteVM()
    var selectFeedData: FeedRawData? = nil
    var isUpdateV: Bool = false
    var loca: CLLocation?
    var address: String?
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Group {
                            Text("주소")
                                .font(.medium(size: 16))
                                .foregroundColor(.white)
                            Spacer().frame(height: 15)
                            Text(addr)
                                .font(.medium(size: 16))
                                .foregroundColor(.white)
                            Spacer().frame(height: 15)
                            Text("제목")
                                .font(.medium(size: 16))
                                .foregroundColor(.white)
                            Spacer().frame(height: 15)
                            TextField("", text: $title)
                                .tint(.blue)
                                .foregroundColor(.gray)
                                .frame(height: 35)
                                .autocapitalization(.none)
                                .disableAutocorrection(false)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Button {
                                            self.endEditing(true)
                                        } label: {
                                            Text("닫기")
                                                .font(.bold(size: 17))
                                                .foregroundColor(.blue)
                                        }
                                        Spacer()
                                    }
                                }
                                .background(
                                    HStack {
                                        if title.isEmpty {
                                            Text("제목을 입력해주세요")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
                                    }
                                )
                                .modifier(GrayBox())
                            Spacer().frame(height: 30)
                        }
                        
                        Text("내용")
                            .font(.medium(size: 16))
                            .foregroundColor(.white)
                        Spacer().frame(height: 15)
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $comment)
                                .tint(.blue)
                                .colorMultiply(Color(hexString: "f7f7f7"))
                                .foregroundColor(.gray)
                                .frame(height: 132)
                                .autocapitalization(.none)
                                .disableAutocorrection(false)
                                .modifier(GrayBox())
                            
                            if comment.isEmpty {
                                Text("내용을 입력해주세요")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.top, 20)
                                    .padding(.horizontal, 20)
                            }
                        }
                        Group {
                            Spacer().frame(height: 12)
                            Text("※ 부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                            Spacer().frame(height: 30)
                            HStack(spacing: 0) {
                                Text("이미지 선택")
                                    .font(.medium(size: 16))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("최대 3장")
                                    .font(.medium(size: 16))
                                    .foregroundColor(.white)
                            }
                            Spacer().frame(height: 12)
                            Group {
                                HStack(spacing: 0) {
                                    Button {
                                        if self.imgs.count > 0 {
                                            self.imgs.remove(at: 0)
                                        } else {
                                            self.showPhotoPicker = true
                                        }
                                    } label: {
                                        if self.imgs.count > 0 {
                                            Image(uiImage: imgs[0])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: g.size.width / 3 - 60, height: 65)
                                                .modifier(GrayBox())
                                                .overlay(alignment: .topTrailing) {
                                                    Image("btnClose01")
                                                        .offset(x: 5, y: -5)
                                                }
                                        } else {
                                            Image("icoPlus-1")
                                                .frame(width: g.size.width / 3 - 60, height: 65)
                                                .modifier(GrayBox())
                                        }
                                        
                                    }
                                    Spacer().frame(height: 10)
                                    Button {
                                        if self.imgs.count > 1 {
                                            self.imgs.remove(at: 1)
                                        } else {
                                            self.showPhotoPicker = true
                                        }
                                    } label: {
                                        if self.imgs.count > 1 {
                                            Image(uiImage: imgs[1])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: g.size.width / 3 - 60, height: 65)
                                                .modifier(GrayBox())
                                                .overlay(alignment: .topTrailing) {
                                                    Image("btnClose01")
                                                        .offset(x: 5, y: -5)
                                                }
                                        } else {
                                            Image("icoPlus-1")
                                                .frame(width: g.size.width / 3 - 60, height: 65)
                                                .modifier(GrayBox())
                                        }
                                        
                                    }
                                    Spacer().frame(height: 10)
                                    Button {
                                        if self.imgs.count > 2 {
                                            self.imgs.remove(at: 2)
                                        } else {
                                            self.showPhotoPicker = true
                                        }
                                    } label: {
                                        if self.imgs.count > 2 {
                                            Image(uiImage: imgs[2])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: g.size.width / 3 - 60, height: 65)
                                                .modifier(GrayBox())
                                                .overlay(alignment: .topTrailing) {
                                                    Image("btnClose01")
                                                        .offset(x: 5, y: -5)
                                                }
                                        } else {
                                            Image("icoPlus-1")
                                                .frame(width: g.size.width / 3 - 60, height: 65)
                                                .modifier(GrayBox())
                                        }
                                        
                                    }
                                    
                                }

                            }
                        }
                       
                        Spacer().frame(height: 40)
                        if isUpdateV {
                            VStack(alignment: .center) {
                                Button {
                                    self.alertType = .feedDeleteConfirm
                                    self.showAlert = true
                                } label: {
                                    Text("삭제하기")
                                        .underline()
                                        .foregroundColor(Color.red)
                                }
                                
                                Spacer().frame(height: 40)
                            }
                            .frame(width: g.size.width - 40)
                        }
                        Spacer().frame(height: 20)
                        Button {
                            if title == "" {
                                self.alertType = .feedTitleNotExists
                                self.showAlert = true
                            } else if comment == "" {
                                self.alertType = .feedCommentNotExists
                                self.showAlert = true
                            }else if self.imgs.count <= 0 {
                                self.alertType = .feedImgNotExists
                                self.showAlert = true
                            } else {
                                var params: [String: Any] = [
                                    "title" : title,
                                    "addr" : addr,
                                    "comment" : comment
                                ]
                                
                                guard let memid = UDF.string(forKey: "memId"),
                                      let loca = self.loca else {
                                    return
                                }
                                
                                
                                let latitude = String(format: "%.4f", Double(loca.coordinate.latitude))
                                let longitude = String(format: "%.4f", Double(loca.coordinate.longitude))
                               
                                params.updateValue(latitude, forKey: "latitude")
                                params.updateValue(longitude, forKey: "longitude")
                                
                                params.updateValue(memid, forKey: "memid")
                                
                                if isUpdateV {
                                    guard let id = selectFeedData?.id  else { return }
                                    params.updateValue(id, forKey: "id")
                                    self.isLoading = true
                                    self.vm.updateFeed(fileImg: self.imgs, info: params) {
                                        self.isLoading = false
                                    }
                                } else {
                                    self.isLoading = true
                                    self.vm.insertFeed(fileImg: self.imgs, info: params) {
                                        self.isLoading = false
                                    }
                                }
                            }
                        } label: {
                            Text("완료")
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .font(.medium(size: 16))
                                .foregroundColor(.white)
                                .background(.black)
                                .cornerRadius(16)
                        }
                    }
                    .padding(20)
                    .frame(width: g.size.width)
                    .frame(minHeight: g.size.height)
                    
                }
                if isLoading {
                    CommonLoadingV()
                }

            }
            .navigationTitle("피드등록")
        }
        .background(DARK_COLOR)
        .onReceive(self.keyboardManager.updateKeyboardStatus) { updatedStatus in
            self.keyboardStatus = updatedStatus
            print("높이: \(keyboardManager.keyboardHeight)")
        }
        .onReceive(vm.$isSuccess) { isSuccess in
            self.alertType = .feedWriteSuccess
            self.showAlert = isSuccess
        }
        .onReceive(vm.$isDeleteSuccess) { isSuccess in
            self.alertType = .feedDeleteSuccess
            self.showAlert = isSuccess
        }
        .onAppear {
            if let feedData = selectFeedData {
                self.title = feedData.title ?? ""
                self.comment = feedData.comment ?? ""
                self.addr = feedData.addr ?? ""
            } else {
                if let addr = self.address {
                    self.addr = addr
                }
            }
        }
        .alert(isPresented: self.$showAlert) {
            let msg: String = alertType.rawValue
            if alertType == .feedWriteSuccess {
                return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
                    NaviManager.popToRootView()
                }))
            } else if alertType == .feedDeleteConfirm {
                return Alert(
                    title: Text(msg),
                    primaryButton: .default(Text("확인"))  {
                        var params = [String: Any]()
                        guard let memid = UDF.string(forKey: "memId"),
                              let id = selectFeedData?.id  else { return }
                        params.updateValue(id, forKey: "id")
                        params.updateValue(memid, forKey: "memid")

                        self.isLoading = true
                        self.vm.removeFeed(info: params) {
                            self.isLoading = false
                            self.alertType = .feedDeleteSuccess
                            self.showAlert = true
                        }
                    },
                    secondaryButton: .cancel(Text("취소")))
            } else if alertType == .feedDeleteSuccess {
                return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
                    NaviManager.popToRootView()
                }))
            }
            return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
            }))
        }
        .sheet(isPresented: $showPhotoPicker) {
            CommonImagePicker(completion: { images in
                self.imgs = images
            }, maxCount: 3)
        }
    }
}

//struct FeedWriteV_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedWriteV(isUpdateV: false)
//    }
//}
