//
//  Kwasniewska_Kurowski_ProjektApp.swift
//  Kwasniewska_Kurowski_Projekt
//
//  Created by Patrycja Kwaśniewska on 07/06/2023.
//

import SwiftUI

@main
struct Kwasniewska_Kurowski_ProjektApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
