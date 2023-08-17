//
//  CommonWebVM.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import Foundation
import Combine

class CommonWebVM: ObservableObject {
    
    @Published var alertMessage: String = ""
    
    var subscription = Set<AnyCancellable>()
    
    var refreshSubject = PassthroughSubject<(), Never>()
    var jsAlertSubject = PassthroughSubject<String, Never>()
    
    var showIndicatorSubject = PassthroughSubject<Bool, Never>()
    
}
