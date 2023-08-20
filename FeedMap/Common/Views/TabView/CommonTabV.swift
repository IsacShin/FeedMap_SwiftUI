//
//  TabView.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/16.
//

import SwiftUI

enum TabType {
    case MAP, FEED, MYPAGE
}

struct CommonTabV: View {
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBar.appearance().backgroundColor = UIColor.darkGray
    }
    
    @State var selectTab: TabType = .MAP
    @State var isLogin = AppManager.isLoggedIn()
    
    var body: some View {
        
        if isLogin {
            TabView(selection: $selectTab) {
                Color.red
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                    .tag(TabType.MAP)

                Color.yellow
                    .tabItem {
                        Image(systemName: "list.bullet.below.rectangle")
                        Text("Feed")
                    }
                    .tag(TabType.FEED)

                MyPageV(selectTab: $selectTab)
                    .tabItem {
                        Image(systemName: "person")
                        Text("My")
                    }
                    .tag(TabType.MYPAGE)
            }
            .tint(.white)
            .onReceive(AppManager.isLogin) {
                isLogin = $0
            }
        } else {
            withAnimation {
                LoginV()
                    .transition(.move(edge: .bottom))
                    .onReceive(AppManager.isLogin) {
                        isLogin = $0
                    }
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        CommonTabV()
    }
}
