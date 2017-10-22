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
    
    private let serviceDependencies:AppServiceDependency
    private let newsHeaderEntity:NewsHeaderEntity
    
    init(navController:UINavigationController, serviceDependencies:AppServiceDependency, news:NewsHeaderEntity) {
        self.navController = navController
        self.serviceDependencies = serviceDependencies
        self.newsHeaderEntity = news
    }
    
    func start() {
        let newsContentVC = UIStoryboard.init(.Main).initVC(NewsContentVC.self)
        configureVC(vc: newsContentVC)
        startNavigation(for: newsContentVC)
    }
}

private extension NewsContentCoordinator {
    func configureVC(vc:NewsContentVC) {
        let presenter = NewsContentPresenter(dependencies: serviceDependencies, news: newsHeaderEntity)
        vc.presenter = presenter
    }
    
    func startNavigation(for vc:NewsContentVC) {
        navController.pushViewController(vc, animated: true)
    }
}
