//
//  SmoreDatabase.swift
//  smore
//
//  Created by Jing Wei Li on 2/25/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreData

enum SmoreDatabase {
    static let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "SmoreDatabase")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container.viewContext
    }()
    
    /// No changes to the database will take effect unless it's saved.
    static func save() throws {
        if context.hasChanges { try context.save() }
    }
}
