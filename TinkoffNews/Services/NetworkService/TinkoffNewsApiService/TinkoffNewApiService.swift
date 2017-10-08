//
//  TinkoffNewApiService.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

let newsPath = "news"
let newsContent = "news_content"

class TinkoffNewsAPIService {
    
    static let baseURL = "https://api.tinkoff.ru/v1"
    static let dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.millisecondsSince1970
    
    let networkService:CoreNetworkProtocol
    
    init(networkService:CoreNetworkProtocol) {
        self.networkService = networkService
    }
    
    func fetchNewsHeaders(completeClojure:@escaping(Error?, NewsQueryResult?) -> Void) -> Void {
        let _ = self.networkService.query(path: newsPath, method: .get, params:nil, requestObject: NewsQueryResult.self, completeClojure:completeClojure)
    }
    
    func fetchNews(id:Int, completeClojure:@escaping(Error?, NewsContentQueryResult?) -> Void) -> Void {
        let queryParams = ["id": String(id)]
        let _ = self.networkService.query(path: newsContent, method: .get, params:queryParams, requestObject: NewsContentQueryResult.self, completeClojure:completeClojure)
    }
    
    
}
