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
    
    lazy private var serviceDependencies:AppServiceDependency = {
        let coreDataStack = CoreDataStack()
        let cacheService = CacheService(coreDataStack: coreDataStack)
        let fetchingController = FetchedNewsController(moc: coreDataStack.currentContext)
        let networkService = NetWorkApiService(baseURL: TinkoffNewsAPIService.baseURL,
                                               dateDecodingStrategy:TinkoffNewsAPIService.dateDecodingStrategy)
        let tinkoffNetworkService = TinkoffNewsAPIService(networkService: networkService)
        
        return AppServiceDependency(tinkoffNewsAPIService: tinkoffNetworkService, cacheService: cacheService,
                                    fetchedController: fetchingController)
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let newsHeadersVC = UIStoryboard.init(.Main).initVC(NewsHeadersVC.self)
        configureVC(vc: newsHeadersVC)
        startNavigation(for:newsHeadersVC)
    }
}

private extension NewsHeaderCoordinator {
    func configureVC(vc:NewsHeadersVC) {
        let presenter = NewsHeaderPresenter(depedencies: serviceDependencies)
        presenter.coordinator = self
        serviceDependencies.fetchedController.fetchingDelegate = vc
        vc.presenter = presenter
    }
    
    func startNavigation(for newsHeadersVC: NewsHeadersVC) {
        navigationController = UINavigationController(rootViewController: newsHeadersVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension NewsHeaderCoordinator: NewsHeaderCoordinatorProtocol {
    func showNewsContent(news: NewsHeaderEntity) {
        guard let navController = navigationController else {
            return;
        }
        let contentCoordinator = NewsContentCoordinator(navController: navController, serviceDependencies: serviceDependencies, news: news)
        contentCoordinator.start()
    }
}
