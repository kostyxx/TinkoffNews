//
//  CoreDataStack.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import CoreData

private let threadContextKey = "threadMOC"

class CoreDataStack {
    
    private let notificationCenter = NotificationCenter.default
    
    init() {
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    var currentContext:NSManagedObjectContext {
        get {
            if Thread.isMainThread {
                return persistentContainer.viewContext
            } else {
                return backgroundContext()
            }
        }
    }
    
    func save() throws {
        if Thread.isMainThread {
            try saveMainQueueContext()
        }
        else {
            try saveBackgroundThreadContext()
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinkoffNews")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

private extension CoreDataStack {
    
    func cachedContext() -> NSManagedObjectContext? {
        let threadDict = Thread.current.threadDictionary
        return threadDict.object(forKey:threadContextKey) as? NSManagedObjectContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        if let threadContext = cachedContext() {
            return threadContext
        }
        else {
            let threadDict = Thread.current.threadDictionary
            let newContext = self.persistentContainer.newBackgroundContext()
            newContext.mergePolicy = NSRollbackMergePolicy
            threadDict.setObject(newContext, forKey: threadContextKey as NSCopying)
            return newContext
        }
    }
    
    func saveBackgroundThreadContext() throws {
        if let threadContext = cachedContext() {
            if threadContext.hasChanges {
                try threadContext.save()
                
            }
        }
    }
    
    func saveMainQueueContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    
    @objc func managedObjectContextDidSave(notification: Notification) {
        persistentContainer.viewContext.perform { () -> Void in
            self.persistentContainer.viewContext.mergeChanges(fromContextDidSave: notification)
        }
    }
}
