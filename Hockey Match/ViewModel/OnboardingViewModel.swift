//
//  OnboardingViewModel.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var data: [OnboardingModel] = [
        .init(title: "Hockey match \nmanagement in one App", imageUrl: HockeyValues.Onboarding.slide0),
        .init(title: "Add teams and player \ninformation", imageUrl: HockeyValues.Onboarding.slide1),
        .init(title: "Plan matches and track \ngame results", imageUrl: HockeyValues.Onboarding.slide2)
    ]
}
