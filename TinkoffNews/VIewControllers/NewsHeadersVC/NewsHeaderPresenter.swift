//
//  PresenterNewsHeader.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

private let kNewsDateFormat = "dd MMMM yyyy HH:mm";

class NewsHeaderPresenter {
    
    typealias Depedencies = HasTinkoffNetworkService & HasCacheService & HasFetchedController
    private let depedencies: Depedencies
    
    private lazy var dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kNewsDateFormat
        return dateFormatter
    }()
    
    var coordinator:NewsHeaderCoordinatorProtocol?
    
    init(depedencies:Depedencies) {
        self.depedencies = depedencies
    }
    
    func updateFetchNewsHeaders(completeClojure:@escaping(Error?) -> Void) {
        func completeFetchingClojure(error:Error?) {
            DispatchQueue.main.async {
                completeClojure(error)
            }
        }
        
        self.depedencies.tinkoffNewsAPIService.fetchNewsHeaders { (error, result) in
            if let networkError = error {
                completeFetchingClojure(error: networkError)
                return
            }
            if let result = result {
                do {
                    let headerNews = result.payload
                    try self.depedencies.cacheService.saveNewsHeader(newsHeaders: headerNews)
                    completeFetchingClojure(error: nil)
                }
                catch {
                    completeFetchingClojure(error: error)
                }
            }
        }
    }
    
   
    
    func newsHeader(indexPath:IndexPath) -> (title:String, date:String) {
        let newsHeader = depedencies.fetchedController.element(indexPath: indexPath) as! NewsHeaderEntity
        let title = newsHeader.text!
        let dateString = dateFormatter.string(from: newsHeader.publicationDate!)
        return (title, dateString)
    }
    
    func numberOfRows() -> Int {
        return depedencies.fetchedController.numberOfRows()
    }
    
    func selectElement(indexPath:IndexPath) {
        let newsHeader = depedencies.fetchedController.element(indexPath: indexPath) as! NewsHeaderEntity
        coordinator?.showNewsContent(news: newsHeader)
    }
    
}
