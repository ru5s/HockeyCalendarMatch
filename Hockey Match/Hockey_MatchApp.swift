//
//  Hockey_MatchApp.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import SwiftUI

@main
struct Hockey_MatchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
