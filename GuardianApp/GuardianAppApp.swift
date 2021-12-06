//
//  GuardianAppApp.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import SwiftUI

@main
struct GuardianAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
