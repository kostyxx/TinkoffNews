//
//  NewsContentPresenter.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

class NewsContentPresenter {
    
    private let networkAPIService:TinkoffNewsAPIService
    private let cacheService:CacheService
    private let news:NewsHeaderEntity
    init(networkAPIService:TinkoffNewsAPIService, cacheService:CacheService, news:NewsHeaderEntity) {
        self.cacheService = cacheService
        self.networkAPIService = networkAPIService
        self.news = news
    }
    
    func fetchContentNews(completionClojure:@escaping (Error?, String?) -> Void) {
        
        if let contentString = news.content?.content {
            completionClojure(nil,contentString)
            return
        }
        let id = Int(news.id)
        networkAPIService.fetchNews(id: id) { [weak self] (error, contentResult) in
            DispatchQueue.main.async {
                if let error = error {
                    completionClojure(error, nil)
                    return
                }
                if let content = contentResult?.payload {
                    do {
                        try self?.cacheService.saveContentNews(content: content, for: self!.news)
                        completionClojure(nil, self?.news.content?.content)
                    } catch {
                        completionClojure(error, nil)
                    }
                }
                
            }
        }
        
    }
    
}
