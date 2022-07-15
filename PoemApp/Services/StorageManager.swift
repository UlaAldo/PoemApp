//
//  DataManager.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PoemApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    

    func fetchData() -> [Poem] {
        let fetchRequest = NSFetchRequest<Poem>(entityName: "Poem")
        do {
            let poems = try viewContext.fetch(fetchRequest)
            return poems
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    func newPoem() -> Poem {
        let poem = NSEntityDescription.insertNewObject(forEntityName: "Poem", into: viewContext) as! Poem
        return poem
    }
    
    func delete(_ poem: Poem) {
        viewContext.delete(poem)
        savePoem()
    }

    func savePoem() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
