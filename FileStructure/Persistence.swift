//
//  Persistence.swift
//  FileStructure
//
//  Created by Varsha Verma on 13/05/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create a fetch request
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        do {
            // Execute the fetch request
            let fetchedRecords = try viewContext.fetch(fetchRequest)
            
            // `fetchedRecords` is an array of `YourEntity` objects
            for record in fetchedRecords {
                // Do something with each record
                print(record)
            }
        } catch let error as NSError {
            // Handle any errors
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FileStructure")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
    func addItem(name : String,pId : String , isFolder : Bool = true,url : String = "") {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let newTask = Folder(context: viewContext)
        newTask.name = name
        newTask.id = UUID().uuidString
        newTask.createdAt = Date()
        newTask.parentId = pId
        newTask.isFolder = isFolder
        newTask.url = url
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
    
