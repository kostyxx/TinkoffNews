//
//  RawApiEntities.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

//MARK: NewsHeaders network entity

struct NewsHeader : Decodable {
    let id:Int
    let name:String
    let text:String
    let publicationDate:Date
    let bankInfoTypeId:Int
    
    enum NewsKeys: String, CodingKey {
        case publicationDate
        case id
        case name
        case text
        case bankInfoTypeId
    }
    enum CodingKeys: String, CodingKey {
        case milliseconds
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NewsKeys.self)
        let dateContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: NewsKeys.publicationDate)
        publicationDate = try dateContainer.decode(Date.self, forKey: .milliseconds)
        
        let idString = try container.decode(String.self, forKey: .id)
        guard let idInt = Int(idString) else {
            let context = DecodingError.Context(codingPath: container.codingPath + [NewsKeys.id], debugDescription: "Could not parse json key to a \(Int.self) object")
            throw DecodingError.dataCorrupted(context)
        }
        id = idInt
        name = try container.decode(String.self, forKey: .name)
        text = try container.decode(String.self, forKey: .text)
        bankInfoTypeId = try container.decode(Int.self, forKey: .bankInfoTypeId)
    }
}

struct NewsQueryResult : Decodable {
    let resultCode:String
    let payload:[NewsHeader]
    let trackingId:String
}

//MARK: Content network entity

struct NewsContent : Decodable {
    let creationDate:Date
    let lastModificationDate:Date
    let content:String
    let bankInfoTypeId:Int
    let typeId:String
    
    enum CodingKeys: String, CodingKey {
        case milliseconds
    }
    enum ContentNewsKeys: String, CodingKey {
        case creationDate
        case lastModificationDate
        case content
        case bankInfoTypeId
        case typeId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContentNewsKeys.self)
        
        let creationDateContaiter = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: ContentNewsKeys.creationDate)
        creationDate = try creationDateContaiter.decode(Date.self, forKey: .milliseconds)
        
        let lastModificationDateContaiter = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: ContentNewsKeys.lastModificationDate)
        lastModificationDate = try lastModificationDateContaiter.decode(Date.self, forKey: .milliseconds)
        
        content = try container.decode(String.self, forKey: .content)
        bankInfoTypeId = try container.decode(Int.self, forKey: .bankInfoTypeId)
        typeId = try container.decode(String.self, forKey: .typeId)
    }
}

struct NewsContentQueryResult : Decodable {
    let resultCode:String
    let payload:NewsContent
    let trackingId:String
}
