//
//  SplashViewModel.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import Foundation

class SplashViewModel: ObservableObject {
    @Published var timer: Double = 0.0
    let userDefaults = UserDefaults()
    
    func starTtimer(completion: @escaping (SplashAction) -> Void) {
        URLSessionRequests.shared.getData()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { time in
            if self.timer <= 0.3 {
                self.timer += 0.15
            } else if self.timer <= 0.9 {
                self.timer += 0.1
            } else {
                time.invalidate()
                self.timer = 1.0
                
                let showedOnboarding = self.userDefaults.bool(forKey: HockeyValues.Show.onboarding)
                if showedOnboarding {
                    completion(.tab)
                } else {
                    completion(.onboard)
                }
            }
        }
    }
}

enum SplashAction {
    case onboard
    case tab
}
