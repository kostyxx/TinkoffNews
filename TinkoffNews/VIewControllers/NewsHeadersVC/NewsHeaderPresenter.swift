//
//  PresenterNewsHeader.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

private let kDateFormat = "dd MMMM yyyy HH:mm";

class NewsHeaderPresenter {
    
    lazy var dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormat
        return dateFormatter
    }()
    
    var coordinator:NewsHeaderCoordinatorProtocol?
    
    private let networkAPIService:TinkoffNewsAPIService
    private let fetchingController:FetchedController
    private let cacheService:CacheService
    
    
    init(networkAPIService:TinkoffNewsAPIService, fetchingController:FetchedController,cacheService:CacheService) {
        self.networkAPIService = networkAPIService
        self.fetchingController = fetchingController
        self.cacheService = cacheService
    }
    
    
    func updateFetchNewsHeaders(completeClojure:@escaping(Error?) -> Void) {
        func completeFetchingClojure(error:Error?) {
            DispatchQueue.main.async {
                completeClojure(error)
            }
        }
        
        self.networkAPIService.fetchNewsHeaders { (error, result) in
            if let networkError = error {
                completeFetchingClojure(error: networkError)
                return
            }
            if let result = result {
                do {
                    let headerNews = result.payload
                    try self.cacheService.saveNewsHeader(newsHeaders: headerNews)
                    completeFetchingClojure(error: nil)
                }
                catch {
                    completeFetchingClojure(error: error)
                }
            }
        }
    }
    
   
    
    func newsHeader(indexPath:IndexPath) -> (title:String, date:String) {
        let newsHeader = self.fetchingController.element(indexPath: indexPath) as! NewsHeaderEntity
        let title = newsHeader.text!
        let dateString = dateFormatter.string(from: newsHeader.publicationDate!)
        return (title, dateString)
    }
    
    func numberOfRows() -> Int {
        return self.fetchingController.numberOfRows()
    }
    
    func selectElement(indexPath:IndexPath) {
        let newsHeader = self.fetchingController.element(indexPath: indexPath) as! NewsHeaderEntity
        coordinator?.showNewsContent(news: newsHeader)
    }
    
}
