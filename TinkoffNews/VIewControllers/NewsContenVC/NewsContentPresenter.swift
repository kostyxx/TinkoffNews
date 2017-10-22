//
//  NewsContentPresenter.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

class NewsContentPresenter {
    
    typealias NewContentServiceDependencies = HasCacheService & HasTinkoffNetworkService
    private let depencencies:NewContentServiceDependencies
    private let news:NewsHeaderEntity
    
    
    init(dependencies: NewContentServiceDependencies, news:NewsHeaderEntity) {
        self.news = news
        self.depencencies = dependencies
    }
    
    func fetchContentNews(completionClojure:@escaping (Error?, String?) -> Void) {
        
        if let contentString = news.content?.content {
            completionClojure(nil,contentString)
            return
        }
        let id = Int(news.id)
        depencencies.tinkoffNewsAPIService.fetchNews(id: id) { [weak self] (error, contentResult) in
            DispatchQueue.main.async {
                if let error = error {
                    completionClojure(error, nil)
                    return
                }
                if let content = contentResult?.payload {
                    do {
                        try self?.depencencies.cacheService.saveContentNews(content: content, for: self!.news)
                        completionClojure(nil, self?.news.content?.content)
                    } catch {
                        completionClojure(error, nil)
                    }
                }
            }
        }
    }
}
