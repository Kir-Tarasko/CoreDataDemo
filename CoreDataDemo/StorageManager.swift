//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Кирилл Тараско on 25.01.2022.
// 

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let taskList = try persistentContainer.viewContext.fetch(fetchRequest)
            completion(taskList)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveData(_ taskName: String, completion: (Task) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext) else {
            return
    }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as? Task else { return }
        task.name = taskName
        completion(task)
    }
}
