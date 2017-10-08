//
//  NewsContentCoordinator.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class NewsContentCoordinator {
    
    private let navController:UINavigationController
    private let cacheService:CacheService
    private let networkService:TinkoffNewsAPIService
    private let newsHeaderEntity:NewsHeaderEntity
    
    init(navController:UINavigationController, cacheService:CacheService,  networkService:TinkoffNewsAPIService, news:NewsHeaderEntity) {
        self.navController = navController
        self.cacheService = cacheService
        self.networkService = networkService
        self.newsHeaderEntity = news
    }
    
    func start() {
        let presenter = NewsContentPresenter(networkAPIService: networkService, cacheService: cacheService,  news:newsHeaderEntity)
        
        let newsContentVC = UIStoryboard.init(.Main).initVC(NewsContentVC.self)
        newsContentVC.presenter = presenter
        
        navController.pushViewController(newsContentVC, animated: true)
    }
}
