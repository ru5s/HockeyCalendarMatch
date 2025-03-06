//
//  SplashView.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var model = SplashViewModel()
    @State var openTabView: Bool = false
    @State var openOnboard: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                links
                logoPlusProgress
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(red: 0.11, green: 0.11, blue: 0.11).ignoresSafeArea()
            )
            .onAppear(){
                model.starTtimer { state in
                    switch state {
                    case .onboard:
                        openOnboard.toggle()
                    case .tab:
                        openTabView.toggle()
                    }
                }
            }
            .ignoresSafeArea()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var links: some View {
        VStack {
            NavigationLink(destination:
                            OnboardView()
                .navigationBarHidden(true), isActive: $openOnboard, label: {EmptyView()})
            NavigationLink(destination:
                            TabViewHockey()
                .navigationBarHidden(true), isActive: $openTabView, label: {EmptyView()})
        }
    }
    
    private var logoPlusProgress: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(HockeyValues.Logo.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 280)
                    .ignoresSafeArea()
                    .padding(.bottom, 10)
                    .offset(y: -100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            VStack {
                progressLine(progress: model.timer)
                Text("Loading \(convertToPercentage())%")
                    .font(Font.system(size: 17, weight: .regular))
                    .foregroundColor(Color.gray)
            }
            .padding(.bottom, 150)
        }
    }
    private func convertToPercentage() -> Int{
        return Int(model.timer * 100.0)
    }
    private func progressLine(progress: CGFloat) -> some View {
            HStack(spacing: 0) {
                let width: CGFloat = 305
                RoundedRectangle(cornerRadius: 25, style: .circular)
                    .fill(Color.blue)
                    .frame(width: (width * (progress)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .animation(.easeIn)
            }
            .frame(width: 305, height: 3)
            .background(Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .circular))
        }
}

#Preview {
    SplashView()
}
