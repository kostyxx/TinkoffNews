//
//  NewsHeaderCoordinator.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol NewsHeaderCoordinatorProtocol:AnyObject {
    func showNewsContent(news:NewsHeaderEntity)
}

class NewsHeaderCoordinator {
    
    private let window: UIWindow
    private var navigationController:UINavigationController?
    private var cacheService:CacheService?
    private var tinkoffNetworkService:TinkoffNewsAPIService?
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let coreDataStack = CoreDataStack()
        cacheService = CacheService(coreDataStack: coreDataStack)
        let fetchingController = FetchedController(moc: coreDataStack.currentContext)
        
        let networkService = NetWorkApiService(baseURL: TinkoffNewsAPIService.baseURL,
                                               dateDecodingStrategy:TinkoffNewsAPIService.dateDecodingStrategy)
        tinkoffNetworkService = TinkoffNewsAPIService(networkService: networkService)
        
        let presenter = NewsHeaderPresenter(networkAPIService: tinkoffNetworkService!,
                                            fetchingController: fetchingController, cacheService: cacheService!)
        presenter.coordinator = self
        
        let newsHeadersVC = UIStoryboard.init(.Main).initVC(NewsHeadersVC.self)
        
        newsHeadersVC.presenter = presenter
        fetchingController.fetchingDelegate = newsHeadersVC
        navigationController = UINavigationController(rootViewController: newsHeadersVC)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}

extension NewsHeaderCoordinator: NewsHeaderCoordinatorProtocol {
    func showNewsContent(news: NewsHeaderEntity) {
        guard let navController = navigationController,
            let cacheService = cacheService,
            let tinkoffNetworkService = tinkoffNetworkService else {
                return;
        }
        let contentCoordinator = NewsContentCoordinator(navController:navController, cacheService:cacheService,
                                                        networkService:tinkoffNetworkService, news:news)
        contentCoordinator.start()
    }
}
