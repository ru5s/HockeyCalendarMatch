//
//  OnboardView.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

struct OnboardView: View {
    @ObservedObject var model: OnboardingViewModel = OnboardingViewModel()
    @State var activeTab: Int = 0
    @State var openTabView: Bool = false
    var body: some View {
        NavigationView{
            ZStack {
                links
                slides
                    .ignoresSafeArea()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var links: some View {
        NavigationLink(destination:
                        TabViewHockey()
            .navigationBarHidden(true), isActive: $openTabView, label: {EmptyView()})
    }
    
    private var slides: some View {
        TabView(selection: $activeTab,
                content:  {
            ForEach(Array(model.data.enumerated()), id: \.element) { index, slide in
                slideView(data: slide, active: activeTab)
                    .tag(index)
            }
        })
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut)
        .background(Color(red: 0.05, green: 0.05, blue: 0.07))
    }

    private func slideView(data: OnboardingModel, active: Int) -> some View {
        ZStack {
            Image(data.imageUrl)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
            let rectangleColor = Color(red: 0.1, green: 0.12, blue: 0.22)
            Rectangle()
                .fill(Color.clear)
                .background(
                    LinearGradient(colors: [
                        rectangleColor.opacity(0.0),
                        rectangleColor,
                        rectangleColor,
                        rectangleColor],
                                   startPoint: .top, endPoint: .bottom)
                )
                .overlay(
                    VStack(spacing: 20) {
                        Text(data.title)
                            .font(Font.system(size: 28, weight: .bold))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                        
                        dots(count: 3, active: active)
                            .padding(.top, 15)
                        Button(action: {
                            if activeTab < model.data.count - 1 {
                                activeTab += 1
                            } else {
                                saveState()
                            }
                        }, label: {
                            Text("NEXT")
                                .fontWeight(.semibold)
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.horizontal, 16)
                        })
                    }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 70)
                )
                .frame(height: 480)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(.all, edges: .bottom)
            
        }
    }
    
    private func dots(count: Int, active: Int) -> some View {
        HStack {
            ForEach(0..<count, id: \.self) { int in
                RoundedRectangle(cornerRadius: 50, style: .circular)
                    .fill(int == active ? Color.white : Color.gray)
                    .frame(width: 8, height: 8, alignment: .center)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.1))
        .clipShape(Capsule())
        .frame(maxWidth: .infinity)
    }
    
    private func saveState() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: HockeyValues.Show.onboarding)
        openTabView.toggle()
    }
}

#Preview {
    OnboardView()
}
