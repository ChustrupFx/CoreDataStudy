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
            NavigationStack {
                TabView {
                    CatList()
                        .tabItem {
                            Label("List", systemImage: "list.bullet.clipboard")
                        }
                    
                    CatSelectorView()
                        
                        .tabItem {
                            Label("Selector", systemImage: "cursorarrow")
                        }
                    
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
