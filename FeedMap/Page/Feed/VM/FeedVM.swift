//
//  FeedVM.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/25.
//

import Foundation
import Combine

class FeedVM: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    var feedListRawData = PassthroughSubject<[FeedRawData]?, Never>()
    var isActionSheetShowing = PassthroughSubject<Bool, Never>()
    var selectFeedIdx = PassthroughSubject<Int, Never>()

    @Published var isReportFailed: Bool = false
    @Published var isReportSuccess: Bool = false
    @Published var isReportExist: Bool = false
    
    func getFeedList(type:String = "all", completion: (() -> Void)?) {
     
        var param = [String: Any]()
        if let memId = UDF.string(forKey: "memId") {
            param.updateValue(memId, forKey: "memid")
        }
        
        param.updateValue(type, forKey: "type")
        
        MapApiService.getFeedList(info: param)
            .sink { complete in
                print("MapVM completion: \(complete)")
                switch complete {
                case .finished:
                    print("MapVM completion: finished")
                    completion?()
                case .failure(let error):
                    print("MapVM completion: failure(\(error))")
                }
            } receiveValue: { result in
                self.feedListRawData.send(result.list)
            }
            .store(in: &subscriptions)
    }
    
    func insertReport(info: [String: Any], completion: @escaping () -> Void) {
        FeedApiService.insertReport(info: info)
            .sink { complete in
                print("FeedWriteVM completion: \(complete)")
                switch complete {
                case .finished:
                    print("FeedWriteVM completion: finished")
                case .failure(let error):
                    print("FeedWriteVM completion: failure(\(error))")
                    self.isReportFailed = true
                }
            } receiveValue: { result in
                if result.resultCode == 200 {
                    self.isReportSuccess = true
                    completion()
                } else if result.resultCode == 300 {
                    self.isReportExist = true
                } else {
                    self.isReportFailed = true
                }
            }
            .store(in: &self.subscriptions)
        
    }
}
