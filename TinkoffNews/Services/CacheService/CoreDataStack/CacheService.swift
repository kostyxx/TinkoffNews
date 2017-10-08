//
//  CacheService.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import CoreData

class CacheService {
    
    let coreDataStack:CoreDataStack
    
    init(coreDataStack:CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func saveNewsHeader(newsHeaders:[NewsHeader]) throws {
        let entityName = String(describing: NewsHeaderEntity.self)
        
        let _ = newsHeaders.map { rawHeader -> NewsHeaderEntity in
            let newsHeaderEntity = NSEntityDescription.insertNewObject(forEntityName:entityName, into: coreDataStack.currentContext) as! NewsHeaderEntity
            newsHeaderEntity.id = Int64(rawHeader.id)
            newsHeaderEntity.name = rawHeader.name
            newsHeaderEntity.text = rawHeader.text
            newsHeaderEntity.publicationDate = rawHeader.publicationDate
            newsHeaderEntity.bankInfoTypeId = Int64(rawHeader.bankInfoTypeId)
            return newsHeaderEntity
        }
        try coreDataStack.save()
    }
    
    func saveContentNews(content:NewsContent, for header:NewsHeaderEntity) throws {
        let entityName = String(describing: NewsContentEntity.self)
        let contentEntity = NSEntityDescription.insertNewObject(forEntityName:entityName, into: coreDataStack.currentContext) as! NewsContentEntity
        contentEntity.title = header
        contentEntity.creationDate = content.creationDate
        contentEntity.lastModificationDate = content.lastModificationDate
        contentEntity.content = content.content
        contentEntity.bankInfoTypeId = Int64(content.bankInfoTypeId)
        contentEntity.typeId = content.typeId
        
        try coreDataStack.save()
    }
    
    
    
}
