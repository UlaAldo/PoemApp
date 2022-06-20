//
//  DataManager.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
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
    
    // MARK: - Public Methods
    func fetchData(completion: (Result<[Poem], Error>) -> Void) {
        let fetchRequest = Poem.fetchRequest()
        
        do {
            let poems = try viewContext.fetch(fetchRequest)
            completion(.success(poems))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func save(_ header: String, _ text: String, completion: (Poem) -> Void) {
        let poem = Poem(context: viewContext)
        poem.headerPoem = header
        poem.textPoem = text
        completion(poem)
        saveContext()
    }
    
    func edit(_ poem: Poem, newHeader: String, newText: String) {
        poem.headerPoem = newHeader
        poem.textPoem = newText
        saveContext()
    }
    
    func delete(_ poem: Poem) {
        viewContext.delete(poem)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
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
