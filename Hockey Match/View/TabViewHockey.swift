//
//  TabViewHockey.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

struct TabViewHockey: View {
    @State var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeVIew(selectedTab: $selectedTab)
                .navigationTitle("Statistics")
                .tabItem({
                    Label("", systemImage: "house")
                })
                .tag(0)
            TeamsView()
                .tabItem({
                    Label("", systemImage: "person.3")
                })
                .tag(1)
            MatchesView()
                .tabItem({
                    Label("", systemImage: "figure.hockey")
                })
                .tag(2)
            SettingsView()
                .tabItem({
                    Label("", systemImage: "gearshape.2")
                })
                .tag(3)
        }
        .accentColor(Color.blue)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(){
            UIScrollView.appearance().isScrollEnabled = true
            
        }
    }
}

#Preview {
    TabViewHockey()
}
