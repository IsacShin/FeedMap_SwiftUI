//
//  TextAlertView.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/25.
//

import SwiftUI
import UIKit

struct TextAlertView: UIViewControllerRepresentable {
    
    @ObservedObject var vm: FeedVM
    @Binding var showAlert: Bool
    @Binding var textString: String
    var feedIdx: Int
    
    var title: String
    var message: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextAlertView>) -> some UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<TextAlertView>) {
        
        guard context.coordinator.uiAlertController == nil else {
            return
        }
        
        if self.showAlert {
            let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            uiAlertController.addTextField { tf in
                tf.placeholder = "신고할 내용을 입력해주세요"
                tf.text = textString
            }
            
            uiAlertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                print("취소가 클릭")
                textString = ""
            }))
            
            uiAlertController.addAction(UIAlertAction(title: "보내기", style: .default, handler: { _ in
                print("보내기 클릭")
                if let tf = uiAlertController.textFields?.first,
                   let text = tf.text {
                    self.textString = text
                }
                
                uiAlertController.dismiss(animated: true) {
                    guard let memid = UDF.string(forKey: "memId") else { return }
                    var param = [String:Any]()
                    param.updateValue(self.feedIdx, forKey: "feedid")
                    param.updateValue(memid, forKey: "reporter")
                    param.updateValue(textString, forKey: "reason")
                    self.vm.insertReport(info: param) {
                        self.vm.getFeedList(type: "all") {
                            self.textString = ""
                            self.showAlert = false
                        }
                    }
                }
            }))
            
            DispatchQueue.main.async {
                WINDOW?.rootViewController?.present(uiAlertController, animated: true) {
                    self.showAlert = false
                    context.coordinator.uiAlertController = nil
                }
            }
        }
        
    }
    
    func makeCoordinator() -> TextAlertView.Coordinator {
        TextAlertView.Coordinator(self)
    }
    
    // UIKit에 델리게이트등을 받는 중간 매개체
    class Coordinator: NSObject {
        var uiAlertController: UIAlertController?
        
        var textAlertView: TextAlertView
        
        init(_ textAlertView: TextAlertView) {
            self.textAlertView = textAlertView
        }
        
    }
    
}

extension TextAlertView.Coordinator: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            self.textAlertView.textString = text.replacingCharacters(in: range, with: string)
        } else {
            self.textAlertView.textString = ""
        }
        return true
    }
}
