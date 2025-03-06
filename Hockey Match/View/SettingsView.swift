//
//  SettingsView.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @State var showUsagePolicy: Bool = false
    @State var urlPolicy: String = "https://www.google.com"
    let ipadDevice = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Divider()
                mainBody
                    .padding(.horizontal, ipadDevice ? 90 : 16)
            }
            .sheet(isPresented: $showUsagePolicy, content: {
                WebView(urlString: urlPolicy, unProtectedMode: true)
                    .ignoresSafeArea()
            })
            .navigationTitle("Settings")
        }
    }
    
    private var mainBody: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                actionButton(type: .usage, icon: "list.bullet.clipboard.fill", title: "Usage Policy")
                    .padding(.top, 20)
                actionButton(type: .share, icon: "square.and.arrow.up.fill", title: "Share app")
                actionButton(type: .rate, icon: "star.fill", title: "Rate Us")
            })
        }
    }
    
    private func actionButton(type: SettingsAction, icon: String, title: String) -> some View {
            Button(action: {
                switch type {
                case .share:
                    shareApp()
                case .rate:
                    rateApp()
                case .usage:
                    showUsagePolicy.toggle()
                }
            }, label: {
                HStack(spacing: 15) {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                    Text(title)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.05, green: 0.05, blue: 0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            })
        }
        
    private func shareApp(){
        DispatchQueue.main.async {
            let appStoreURL = URL(string: "https://apps.apple.com/us/app")!
            let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY / 2, width: 0, height: 0)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
        
    private func rateApp(){
        DispatchQueue.main.async {
            let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive})
            SKStoreReviewController.requestReview(in: scene as! UIWindowScene)
        }
    }

}

#Preview {
    SettingsView()
}

enum SettingsAction {
    case share
    case rate
    case usage
}
