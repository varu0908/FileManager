//
//  FileStructureApp.swift
//  FileStructure
//
//  Created by Varsha Verma on 13/05/24.
//

import SwiftUI

@main
struct FileStructureApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
