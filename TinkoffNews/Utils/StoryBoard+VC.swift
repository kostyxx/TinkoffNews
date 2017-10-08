//
//  StoryBoard+VC.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit


enum AppStoryboardsNames:String {
    case Main
}

extension UIStoryboard {
    convenience init (_ storyboard:AppStoryboardsNames) {
        self.init(name: storyboard.rawValue, bundle: Bundle.main)
    }
    
    func initVC<T>(_ storyBoardType:T.Type) -> T where T : UIViewController {
        let vcClassName:String = NSStringFromClass(storyBoardType).components(separatedBy: ".").last!
        return self.instantiateViewController(withIdentifier: vcClassName) as! T
    }
}
