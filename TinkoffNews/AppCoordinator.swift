//
//  AppCoordinator.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let newsCoordinator = NewsHeaderCoordinator.init(window: window)
        newsCoordinator.start()
    }
    
}
