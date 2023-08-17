//
//  SplashV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/09.
//

import SwiftUI
import AppTrackingTransparency
import AdSupport

struct SplashV: View {
    var idfa: UUID {
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    
    @ObservedObject var vm: SplashVM = SplashVM()
    @State var isAnim = false
    @State var isGuideShow = false
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            DARK_COLOR
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Group {
                    Image("LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: SCREEN_WIDTH - 40, height: 130)
                    Spacer().frame(height: 20)
                    Text("지도로 저장하는 나만의 피드")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .opacity(isAnim ? 1.0 : 0.0)
                }
                .offset(y: -100)
                
                Spacer()
                Text("CopyrightⒸ 2023. ISAC. All Right Reserved.")
                    .foregroundColor(.white)
                    .font(.system(size: 13))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                withAnimation(.easeIn(duration: 1.0)) {
                    self.isAnim = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.vm.startLaunch()
                    }
                }
            })
            
        }
        .onReceive(self.vm.nextAction) { state in
            switch state {
                case .firstLaunch:
                    self.isGuideShow = true
                case .yetLaunch:
                    NaviManager.popToRootView {
                        withAnimation {
                            appState.rootViewId = .CommonTabView
                        }
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            ATTrackingManager.requestTrackingAuthorization { [self] status in
                switch status {
                case .authorized:
                    print("광고추적 허용")
                    print("IDFA: ", self.idfa)
                case .denied, .notDetermined, .restricted:
                    print("광고추적 비허용")
                    print("IDFA: ", self.idfa)
                @unknown default:
                    print("UNKNOWN")
                    print("IDFA: ", self.idfa)
                }
            }
                }
        .fullScreenCover(isPresented: $isGuideShow) {
            AccessGuideV(isGuideShow: $isGuideShow)
        }
    }
}

struct SplashV_Previews: PreviewProvider {
    static var previews: some View {
        SplashV()
    }
}
