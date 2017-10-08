//
//  FetchingResultProtocol.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

protocol FetchingResultDelegate: AnyObject {
    func willUpdate()
    func endUpdate()
    func insertObject(element:AnyObject, indexPath:IndexPath)
}
