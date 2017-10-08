//
//  CoreNetworkProtocol.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // add  another type for full implementation
}

protocol CoreNetworkProtocol {
    func query<T> (path:String?, method:HTTPMethod, params:[String:String]?, requestObject:T.Type,
                   completeClojure:@escaping(Error?, T?) -> Void) -> URLSessionTask? where T:Decodable
}
