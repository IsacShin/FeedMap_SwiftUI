//
//  CommonWebWrapV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import SwiftUI
import iProgressHUD

struct CommonWebV: View {
    @State var urlStr: String = "https://www.naver.com"
    @State var isShowAlert: Bool = false
    @State var isLoading: Bool = false
    @ObservedObject var webVM = CommonWebVM()

    @State var message: String?

    var body: some View {
        ZStack {
            CommonWebV(vm: webVM, urlStr: urlStr)
            
            if isLoading {
                let iprogress = iProgressHUD()
                iprogress.indicatorStyle = .ballTrianglePath
                iprogress.indicatorSize = 30
                iprogress.boxSize = 30
                iprogress.boxCorner = 12
                iprogress.isShowBox = true
                iprogress.isBlurBox = false
                iProgressHUD.sharedInstance().attachProgress(toView: UIApplication.shared.keyWindow)
                self.showProgress()
            }
                
        }
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
        CommonWebV()
    }
}
