//
//  CommonWebWrapV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import SwiftUI
import iProgressHUD

struct CommonWebV: View {
    
    init(urlStr: String) {
        self.urlStr = urlStr
        UINavigationBar.appearance().isTranslucent = true
    }
    
    @State var urlStr: String
    @State var isShowAlert: Bool = false
    @State var isLoading: Bool = false
    @ObservedObject var webVM = CommonWebVM()

    @State var message: String?

    var body: some View {
        ZStack {
            CommonWebView(vm: webVM, urlStr: urlStr)
            
            if isLoading {
                CommonLoadingV()
            }
                
        }
        .background(DARK_COLOR)
        .onReceive(webVM.showIndicatorSubject) { isLoading in
            self.isLoading = isLoading
        }
        .onReceive(webVM.jsAlertSubject) { message in
            webVM.alertMessage = message
            self.isShowAlert = true
        }
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text(webVM.alertMessage), dismissButton: .default(Text("확인"), action: {
                print("알림창 확인")
            }))
        }
    }
}

struct CommonWebWrapV_Previews: PreviewProvider {
    static var previews: some View {
        CommonWebV(urlStr: "https://www.naver.com")
    }
}
