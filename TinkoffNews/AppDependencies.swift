//
//  FlowCoordinator.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 22/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

protocol HasTinkoffNetworkService {
    var tinkoffNewsAPIService: TinkoffNewsAPIService { get }
}
protocol HasCacheService {
    var cacheService: CacheService { get }
}
protocol HasFetchedController {
    var fetchedController: FetchedNewsController { get }
}

struct AppServiceDependency: HasTinkoffNetworkService, HasCacheService, HasFetchedController {
    let tinkoffNewsAPIService:TinkoffNewsAPIService
    let cacheService: CacheService
    let fetchedController: FetchedNewsController
}
