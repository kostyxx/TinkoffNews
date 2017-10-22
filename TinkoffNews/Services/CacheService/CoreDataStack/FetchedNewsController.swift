//
//  FetchedCoordinator.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import CoreData

class FetchedNewsController:NSObject {
    weak var fetchingDelegate:FetchingResultDelegate?
    
    private let moc: NSManagedObjectContext
    private var _fetchedResultsController: NSFetchedResultsController<NewsHeaderEntity>? = nil

    init(moc:NSManagedObjectContext) {
        self.moc = moc
    }
    
    private var fetchedResultsController: NSFetchedResultsController<NewsHeaderEntity> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<NewsHeaderEntity> = NewsHeaderEntity.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "publicationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: "News")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    func element(indexPath:IndexPath) -> AnyObject {
         return fetchedResultsController.object(at: indexPath)
    }
    func numberOfRows() -> Int {
        let sectionInfo = fetchedResultsController.sections![0]
        return sectionInfo.numberOfObjects
    }
}

extension FetchedNewsController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fetchingDelegate?.willUpdate()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
           self.fetchingDelegate?.insertObject(element: anObject as! NewsHeaderEntity , indexPath: newIndexPath!)
        default:
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fetchingDelegate?.endUpdate()
    }
}


