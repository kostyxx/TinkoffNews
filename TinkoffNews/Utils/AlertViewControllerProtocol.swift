//
//  AlertViewControllerProtocol.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 08/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol AlertViewControllerProtocol {
    
}

extension AlertViewControllerProtocol where Self: UIViewController {
    func presentAlert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
