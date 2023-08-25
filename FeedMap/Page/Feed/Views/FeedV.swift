//
//  FeedV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/25.
//

import SwiftUI
import Combine
import Kingfisher

struct FeedV: View {
    @ObservedObject var vm: FeedVM
    var feedData: FeedRawData?
    @State var opacity: Double = 1.0
    @State var images: [String] = [String]()
    @State var imgHeight: CGFloat = 300
    init(vm: FeedVM, feedData: FeedRawData?, opacity: Double = 1.0) {
        self.vm = vm
        self.feedData = feedData
        self.opacity = opacity
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if let id = feedData?.memid {
                    if let myId = UDF.string(forKey: "memId") {
                        if id == myId {
                            if let profileImg = UDF.string(forKey: "profileImg") {
                                let url = URL(string: profileImg)!
                                KFImage(url)
                                    .placeholder {
                                        Image(systemName: "person.circle.fill")
                                    }
                                    .resizable()
                                    .frame(width: 40,height: 40)
                                    .clipShape(Circle())
                                    .aspectRatio(contentMode: .fit)
                                    .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40,height: 40)
                                    .aspectRatio(contentMode: .fit)
                                    .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40,height: 40)
                                .aspectRatio(contentMode: .fit)
                                .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                        }
                    }
                }
                
                
                Spacer().frame(width: 8)
                Text(feedData?.memid ?? "isac9305@gmail.com")
                    .font(.regular(size: 14))
                    .foregroundColor(.white)
                    .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                Spacer()
                
                if let id = feedData?.memid {
                    if let myId = UDF.string(forKey: "memId") {
                        if id != myId {
                            Button {
                                guard let idx = feedData?.id else { return }
                                self.vm.selectFeedIdx.send(idx)
                                self.vm.isActionSheetShowing.send(true)
                            } label: {
                                Text("신고하기")
                                    .font(.regular(size: 13))
                                    .foregroundColor(.red)
                                    .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                    }
                }
                

                Spacer().frame(width: 20)
            }
            Text(feedData?.addr ?? "경기도 의정부시 신흥로")
                .font(.regular(size: 14))
                .foregroundColor(.white)
                .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                .offset(x: 48, y: -5)
                
            Spacer().frame(height: 15)
            
            ImageSliderV(images: self.$images)
            .frame(height: imgHeight)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
            Spacer().frame(height: 15)
            VStack(alignment: .leading, spacing: 6) {
                Text(feedData?.title ?? "테스트 제목")
                    .font(.bold(size: 18))
                    .foregroundColor(.white)
                    .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                Text(feedData?.comment ?? "테스트 내용 입니다.")
                    .font(.regular(size: 16))
                    .foregroundColor(.white)
                    .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                Text(feedData?.date?.wddSimpleDateForm() ?? "0000-00-00 00:00:00")
                    .font(.regular(size: 12))
                    .foregroundColor(.white)
                    .modifier(BlinkingAnimModifier(shouldShow: feedData == nil, opacity: opacity))
                Spacer().frame(height: 14)
            }
            .padding(.horizontal, 20)
            .onAppear(perform: {
                self.images.removeAll()
                var heights = [CGFloat]()
                if let img1 = self.feedData?.img1,
                   let url = URL(string: img1) {
                    self.getURLImageHeight(url: url) { height in
                        self.images.append(img1)
                        heights.append(height)
                        if images.count == 1 {
                            let totalHeight = heights.reduce(0, +)
                            let avgHeight = totalHeight / Double(heights.count)
                            self.imgHeight = avgHeight
                        }
                        if let img2 = self.feedData?.img2,
                           let url = URL(string: img2) {
                            self.getURLImageHeight(url: url) { height in
                                self.images.append(img2)
                                heights.append(height)
                                if images.count == 2 {
                                    let totalHeight = heights.reduce(0, +)
                                    let avgHeight = totalHeight / Double(heights.count)
                                    self.imgHeight = avgHeight
                                }
                                if let img3 = self.feedData?.img3,
                                   let url = URL(string: img3) {
                                    self.getURLImageHeight(url: url) { height in
                                        self.images.append(img3)
                                        heights.append(height)
                                        if images.count == 3 {
                                            let totalHeight = heights.reduce(0, +)
                                            let avgHeight = totalHeight / Double(heights.count)
                                            self.imgHeight = avgHeight
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            })
            
        }
        .frame(maxWidth: .infinity)
        .background(DARK_COLOR)
    }
}

extension FeedV {
    func getURLImageHeight(url: URL, completion: @escaping ((CGFloat) -> Void)) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let rImg):
                let img = rImg.image
                let imgVWidth: CGFloat = SCREEN_WIDTH * 0.8
                
                var imgVHeight = imgVWidth / img.size.width * img.size.height
                let maxSlideHeight: CGFloat = 550
                if imgVHeight > maxSlideHeight {
                    imgVHeight = maxSlideHeight
                }
                completion(imgVHeight)
            case .failure(_):
                print("Not Found Image")
            }
        }
    }
}

struct FeedV_Previews: PreviewProvider {
    static var previews: some View {
        FeedV(vm: FeedVM(), feedData: nil)
    }
}
