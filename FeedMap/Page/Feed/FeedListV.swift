//
//  FeedV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/25.
//

import SwiftUI
import GoogleMobileAds

struct FeedListV: View {
    @State var isMenuOpen = false
    @State var isLoading: Bool = false
    @State var list: [FeedRawData]?
    @ObservedObject var vm = FeedVM()
    @State var isActionSheetShowing = false
    @State var showAlert = false
    @State private var alertType: AlertType = .isReportFailed
    @State var isTextAlertShow = false
    @State var textString = ""
    @State var selectFeedIdx: Int?

    var body: some View {
        GeometryReader { g in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Spacer().frame(width: 20)
                        Text("FeedShare")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 54)
                            .font(.bold(size: 21))
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            withAnimation(.spring()) {
                                self.isMenuOpen.toggle()
                            }
                        } label: {
                            Image("more (1)")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .aspectRatio(contentMode: .fit)
                        }

                        Spacer().frame(width: 20)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    List(self.list ?? []) { feed in
                        FeedV(vm: self.vm, feedData: feed)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(DARK_COLOR)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        self.isLoading = true
                        vm.getFeedList(type: "all") {
                            self.isLoading = false
                        }
                    }
                    
                    AdmobV()
                }

                if isLoading {
                    CommonLoadingV()
                }
                
                if self.list?.count == 0 {
                    DARK_COLOR
                        .overlay {
                            Text("작성된 피드가 없습니다.")
                                .font(.bold(size: 17))
                                .foregroundColor(.white)
                        }
                        .offset(y: 54)
                }
                
                if isMenuOpen {
                    VStack(alignment: .leading) {
                        Button {
                            self.isLoading = true
                            vm.getFeedList(type: "all") {
                                self.isLoading = false
                            }
                        } label: {
                            Text("전체피드")
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        
                        Divider().frame(width: 80, height: 1)
                            .background(Color.white)
                        
                        Button {
                            self.isLoading = true
                            vm.getFeedList(type: "my") {
                                self.isLoading = false
                            }
                        } label: {
                            Text("내피드")
                                .font(.body)
                                .foregroundColor(.white)
                        }

                    }
                    .padding(10)
                    .background(Color.gray)
                    .frame(width: 100)
                    .offset(x: (g.size.width / 2) - 60, y: -(g.size.height / 2) + 94)
                }
                
                if isTextAlertShow {
                    if let idx = self.selectFeedIdx {
                        TextAlertView(vm: self.vm, showAlert: $isTextAlertShow, textString: $textString, feedIdx: idx, title: "신고 접수", message: "")
                    }
                }
                
            }
            .onReceive(self.vm.feedListRawData, perform: { list in
                self.list = list
            })
            .onReceive(vm.$isReportExist) { isSuccess in
                self.alertType = .isReportExist
                self.showAlert = isSuccess
            }
            .onReceive(vm.$isReportSuccess) { isSuccess in
                self.alertType = .isReportSuccess
                self.showAlert = isSuccess
            }
            .onReceive(vm.$isReportFailed) { isSuccess in
                self.alertType = .isReportFailed
                self.showAlert = isSuccess
            }
            
            .onReceive(vm.isActionSheetShowing) { isShow in
                self.isActionSheetShowing = isShow
            }
            .onReceive(vm.selectFeedIdx) { idx in
                self.selectFeedIdx = idx
            }
            .onAppear {
                self.isLoading = true
                vm.getFeedList(type: "all") {
                    self.isLoading = false
                }
            }
            .alert(isPresented: self.$showAlert) {
                let msg: String = alertType.rawValue
                
                return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
                }))
            }
            .confirmationDialog("신고 사유를 선택해주세요.",
                                isPresented: $isActionSheetShowing,
                                titleVisibility: .visible,
                                actions: {
                Button("부적절한 콘텐츠", role: .destructive) { self.insertReport(reason: "부적절한 콘텐츠") }
                Button("상업적 광고", role: .destructive) { self.insertReport(reason: "상업적 광고") }
                Button("음란물", role: .destructive) { self.insertReport(reason: "음란물") }
                Button("폭력성", role: .destructive) { self.insertReport(reason: "폭력성") }
                Button("기타", role: .destructive) {
                    self.isTextAlertShow.toggle()
                }
                Button("취소", role: .cancel) { print("tap cancel") }
            }, message: {
                Text("신고 사유에 맞지 않는 사유일 경우,\n해당 신고는 처리되지 않습니다.\n신고 누적 횟수가 3회 이상일 경우 \n유저는 피드작성을 하실 수 없습니다.")
            })
        }
        .background(DARK_COLOR)
    }
}

extension FeedListV {
    func insertReport(reason: String) {
        guard let memid = UDF.string(forKey: "memId"),
              let idx = self.selectFeedIdx else { return }
        var param = [String:Any]()
        param.updateValue(idx, forKey: "feedid")
        param.updateValue(memid, forKey: "reporter")
        param.updateValue(reason, forKey: "reason")
        self.vm.insertReport(info: param) {
            self.isLoading = true
            self.vm.getFeedList(type: "all") {
                self.isLoading = false
            }
        }
    }
}

@ViewBuilder func AdmobV() -> some View {
    // admob
    let bannerWidth = UIScreen.main.bounds.width
    let bannerSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(bannerWidth)
    GADBanner().frame(width: bannerWidth, height: bannerSize.size.height)

}

struct FeedListV_Previews: PreviewProvider {
    static var previews: some View {
        FeedListV()
    }
}
