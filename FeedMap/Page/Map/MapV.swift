//
//  MapV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import SwiftUI
import GoogleMaps
import GooglePlaces
import Combine

struct MapV: View {
    @ObservedObject var vm = MapVM()
    @State var markersData: [FeedRawData]? = []
    @State var selectedMarker: GMSMarker?
    @State var zoomLevel: Float = 15
    @State var moveLocation: CLLocation?
    @State var alertType: AlertType = .isCheckCurrentLocationFail
    @State var showAlert = false
    @State var showFeedWrite = false
    @State var selectFeedRawData: FeedRawData?
    @State var isUpdateCheck: Bool = false
    @State var isActive = false
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    MapView(
                        markersData: $markersData,
                        zoomLevel: $zoomLevel,
                        moveLocation: $moveLocation,
                        isUpdateCheck: $isUpdateCheck,
                        mapVM: self.vm)
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .center, spacing: 0) {
                        Spacer().frame(height: 16)
                        
                        NavigationLink(destination: CommonWebV(urlStr: "https://isacshin.github.io/daumSearch/"), isActive: $isActive) {
                            Button {
                                GADInterstitial.shared.loadFullAd()
                                isActive.toggle()
                            } label: {
                                Image("searchBar")
                                    .resizable()
                                    .aspectRatio(353/58, contentMode: .fill)
                                    .frame(width: geometry.size.width - 40, height: 58)
                            }

                        }

                        Spacer()
                        Button {
                            guard let location = self.vm.centerLocation else { return }
                            self.vm.getFeedList(true, loca: location) {
                                let check = self.vm.isFeedCheck
                                if check {
                                    if let location = self.vm.centerLocation {
                                        let param = [
                                            "latlng" : "\(location.coordinate.latitude),\(location.coordinate.longitude)",
                                            "key" : GMAP_KEY
                                        ]
                                        self.vm.getAddrGeocode(param: param)
                                        
                                        self.alertType = .feedNotExists
                                        self.showAlert = check
                                    }
                                } else {
                                    self.alertType = .feedExists
                                    self.showAlert = check
                                }
                            }
                        } label: {
                            HStack {
                                Image("cRefres")
                                    .colorMultiply(.black)
                                Spacer().frame(width: 6)
                                Text("현 지역에서 검색")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 137, height: 40)
                            .background(Color.white)
                            .cornerRadius(16)

                        }
                        Spacer().frame(height: 20)
                    }
                    .frame(minHeight: geometry.size.height)

                }
                
                
                if self.vm.isSelectTab {
                    SelectTabV(selectFeedData: $selectFeedRawData)
                }
                
                NavigationLink(
                    destination: FeedWriteV(isUpdateV: false,
                                            loca: self.vm.centerLocation,
                                            address: self.vm.centerAddr),
                    isActive: $showFeedWrite,
                    label: {}
                )
                
            }
            .onAppear {
                self.setNaviBarAppearnce()
                self.vm.isSelectTab = false
                self.vm.checkCurrentLocationAuth {
                    self.vm.getFeedList(false, loca: nil) {
                        self.vm.isUpdateCheck = true
                    }
                }
            }
            .onReceive(self.vm.currentLocation) { location in
                guard let location = location else { return }
                self.vm.isUpdateCheck = true
                self.moveLocation = location
            }
            .onReceive(self.vm.isCheckCurrentLocationFail) { check in
                self.alertType = .isCheckCurrentLocationFail
                self.showAlert = check
            }
            .onReceive(self.vm.moveLocation) { location in
                guard let location = location else { return }
                self.vm.isUpdateCheck = true
                self.moveLocation = location
                self.vm.getFeedList(true, loca: location) {
                    let check = self.vm.isFeedCheck
                    if check {
                        self.alertType = .feedNotExists
                        self.showAlert = check
                    } else {
                        self.alertType = .feedExists
                        self.showAlert = check
                    }
                }
            }
            .onReceive(self.vm.feedListRawData) { list in
                self.vm.isUpdateCheck = true
                self.markersData = list
            }
            .onReceive(self.vm.selectFeedRawData) { data in
                self.selectFeedRawData = data
            }
            .onReceive(self.vm.$isUpdateCheck) { isUpdateCheck in
                self.isUpdateCheck = isUpdateCheck
            }
            
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showAlert) {
            var msg: String = ""
            if alertType == .isCheckCurrentLocationFail {
                msg = AlertType.isCheckCurrentLocationFail.rawValue
                return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
                    guard let uUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    UIApplication.shared.open(uUrl)
                }))
            } else if alertType == .feedExists {
                msg = AlertType.feedExists.rawValue
            } else if alertType == .feedNotExists {
                msg = AlertType.feedNotExists.rawValue
                return Alert(
                    title: Text(msg),
                    primaryButton: .default(Text("확인"))  {
                        GADInterstitial.shared.loadFullAd()
                        self.showFeedWrite.toggle()
                    },
                    secondaryButton: .cancel(Text("취소")) {
                        GADInterstitial.shared.loadFullAd()
                    })
            }

            return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
                NaviManager.popToRootView()
            }))
        }
    }
}

extension MapV {
    func setNaviBarAppearnce() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.darkGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct MapV_Previews: PreviewProvider {
    static var previews: some View {
        MapV(selectFeedRawData: FeedRawData())
    }
}
