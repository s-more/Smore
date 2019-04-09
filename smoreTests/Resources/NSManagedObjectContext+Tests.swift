//
//  NSManagedObjectContext+Tests.swift
//  smoreTests
//
//  Created by Jing Wei Li on 4/8/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import CoreData
import XCTest

extension NSManagedObjectContext {
    
    /// The `mom` and `momd` files are compiled versions of xcdatamodel and xcdatamodeld files.
    class func contextForTests(using bundle: Bundle) -> NSManagedObjectContext {
        // Get the model
        let path = bundle.path(forResource: "SmoreDatabase", ofType: "momd")!
        let url = URL(fileURLWithPath: path)
        let model = NSManagedObjectModel(contentsOf: url)!
        
        // Create and configure the coordinator
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(
            ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        // Setup the context
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
}
