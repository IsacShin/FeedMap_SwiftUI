//
//  CommonWebV.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/17.
//

import Foundation
import SwiftUI
import WebKit
import Combine

class RefreshControlHelper: NSObject {
    var vm: CommonWebVM?
    var refreshCTL: UIRefreshControl?
    
    @objc func didRefresh() {
        guard let vm = self.vm,
              let refreshCTL = self.refreshCTL else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            vm.refreshSubject.send()
            refreshCTL.endRefreshing()
        })
    }
}

struct CommonWebView: UIViewRepresentable {
    
    @ObservedObject var vm: CommonWebVM
    var rfcHelper = RefreshControlHelper()
    var urlStr: String
    
    
    func makeCoordinator() -> CommonWebView.Coordinator {
        return CommonWebView.Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlStr) else { return WKWebView() }
        let webV = WKWebView(frame: .zero, configuration: self.createWebConfig())
        webV.uiDelegate = context.coordinator
        webV.navigationDelegate = context.coordinator
        webV.allowsBackForwardNavigationGestures = true
        
        let rfc = UIRefreshControl()
        rfc.tintColor = .blue
        webV.scrollView.bounces = true
        webV.scrollView.refreshControl = rfc
        
        rfcHelper.vm = self.vm
        rfcHelper.refreshCTL = rfc
        
        rfc.addTarget(rfcHelper, action: #selector(RefreshControlHelper.didRefresh), for: .valueChanged)
        
        webV.load(URLRequest(url: url))
        
        return webV
        
        
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<CommonWebView>) {
        
    }
    
    func createWebConfig() -> WKWebViewConfiguration {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let wkWebConfig = WKWebViewConfiguration()
        
        let userContentController = WKUserContentController()
        userContentController.add(self.makeCoordinator(), name: "W2A")
        wkWebConfig.userContentController = userContentController
        wkWebConfig.preferences = preferences
        
        return wkWebConfig
    }
    
    class Coordinator: NSObject {
        var webV: CommonWebView
        var subscriptions = Set<AnyCancellable>()
        
        init(_ webV: CommonWebView) {
            self.webV = webV
        }
    }
    
    
}

extension CommonWebView.Coordinator: WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        webV
            .vm
            .jsAlertSubject
            .send(message)
        completionHandler()
    }
}

extension CommonWebView.Coordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webV
            .vm
            .showIndicatorSubject
            .send(true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        switch url.scheme {
        case "tel", "mailto":
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webV
            .vm
            .showIndicatorSubject
            .send(false)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webV
            .vm
            .showIndicatorSubject
            .send(false)
    }
}

extension CommonWebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
        
        if message.name == "W2A" {
            print("\(message.body)")
            guard let body = message.body as? [String: Any] else {
                return
            }
            
            guard let jibunAddress = body["jibunAddress"] as? String,
                  let roadAddress = body["roadAddress"] as? String,
                  let zonecode = body["zonecode"] as? String else { return }
            
            print("\(jibunAddress)\n\(roadAddress)\n\(zonecode)")

            NaviManager.popViewController {
                var userInfo = [String: Any]()
                
                userInfo["jibunAddress"] = jibunAddress
                userInfo["roadAddress"] = roadAddress
                userInfo["zonecode"] = zonecode
                
                NotificationCenter
                    .default
                    .post(name: Notification.Name("addrInfo"),
                          object: nil,
                          userInfo: userInfo)
            }
            
        }
    }
}
