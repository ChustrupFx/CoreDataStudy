//
//  CoreDataStudyApp.swift
//  CoreDataStudy
//
//  Created by Victor Soares on 10/08/23.
//

import SwiftUI

@main
struct CoreDataStudyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
