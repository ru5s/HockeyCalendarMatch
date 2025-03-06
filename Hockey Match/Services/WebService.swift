//
//  WebService.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI
import WebKit
import AVFoundation

class NoScreenshotWebView: WKWebView {
    override func layoutSubviews() {
        super.layoutSubviews()
        stopScreenCapture()
    }
    
    func stopScreenCapture() {
        let session = AVCaptureSession()
        session.outputs.forEach { output in
            session.removeOutput(output)
        }
        session.inputs.forEach { input in
            session.removeInput(input)
        }
        let userDefault = UserDefaults()
        userDefault.set(false, forKey: "screenRecordingEnabled")
    }
}


struct WebView: UIViewRepresentable {
    let urlString: String
    let webView: NoScreenshotWebView = NoScreenshotWebView()
    let unProtectedMode: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, reglament: unProtectedMode)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var timer: Timer?
        var reglament: Bool
        
        init(_ parent: WebView, reglament: Bool) {
            self.parent = parent
            self.reglament = reglament
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Start download
            if reglament == false {
                timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(handleTimeout), userInfo: nil, repeats: false)
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let userDefault = UserDefaults()
            // Download succed
            if reglament == false {
                userDefault.set(true, forKey: HockeyValues.Show.first)
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // Error download
        }
        
        @objc func handleTimeout() {
            let userDefault = UserDefaults()
            let firstOpen = userDefault.bool(forKey: HockeyValues.Show.first)
            // 5 second gone
            if !parent.webView.isLoading {
                if !firstOpen {
                    userDefault.set("https://www.google.com", forKey: "partnerLink")
                }
                
            }
        }
    }
}


