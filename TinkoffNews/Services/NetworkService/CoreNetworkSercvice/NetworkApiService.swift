//
//  NetworkApiService.swift
//  TinkoffNews
//
//  Created by Konstantin Malakhov on 07/10/2017.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation


class NetWorkApiService:CoreNetworkProtocol {
    
    private let baseURL:String
    
    lazy private var decoder:JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }()
    
    private let dateDecodingStrategy:JSONDecoder.DateDecodingStrategy
    
    public required init(baseURL: String, dateDecodingStrategy:JSONDecoder.DateDecodingStrategy) {
        self.baseURL = baseURL
        self.dateDecodingStrategy = dateDecodingStrategy
    }
    
    public func query<T> (path:String?, method:HTTPMethod, params:[String:String]?, requestObject:T.Type,
                          completeClojure:@escaping(Error?, T?) -> Void) -> URLSessionTask? where T:Decodable {
        
        guard let url = url(baseURL: baseURL, pathURL: path, httpMethod:method, params:params) else {
            print("Error: cannot create URL")
            return nil
        }
        
        let request = urlRequest(url:url, method:method, params:params)
        
        let task = self.task(requestObject: T.self, request: request, completeClosure:completeClojure)
        task.resume()
        return task
    }
}

public enum APIError: Error, LocalizedError {
    case wrongStatusCode(Int)
    public var errorDescription: String? {
        switch self {
        case .wrongStatusCode(let statusCode):
            return "server error with status code \(statusCode)" // TODO:localize
        }
    }
}

private extension NetWorkApiService {
    
    func url(baseURL:String, pathURL:String?, httpMethod:HTTPMethod, params:[String:String]? = nil) -> URL? {
        guard var url = URL(string:baseURL) else {
            return nil
        }
        if let pathURL = pathURL {
            url.appendPathComponent(pathURL)
        }
        
        switch httpMethod {
        case .get:
            if let params = params  {
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
                urlComponents.queryItems = queryItems(params: params)
                if let urlWithComponents = urlComponents.url {
                    url = urlWithComponents
                }
            }
        case .post:
            break
        }
        return url
    }
    
    func queryItems(params:[String:String]) -> [URLQueryItem] {
        return params.keys.map { key -> URLQueryItem in
            URLQueryItem(name: key, value: params[key])
        }
    }
    
    
    func urlRequest(url:URL, method:HTTPMethod, params:[String:String]?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        switch method {
        case .post:
            if let params = params {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            urlRequest.httpBody = jsonData
            }
        case .get:
            break
        }
        
        return urlRequest
    }
    
  
    
    func task<T>(requestObject:T.Type, request:URLRequest,
                 completeClosure:@escaping (Error?, T?) -> Void) -> URLSessionTask where T:Decodable {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, networkError) in
            if let networkError = networkError {
                completeClosure(networkError, nil)
                return
            }
            
            if let response = response, let serverError = self.checkError(from: response) {
                completeClosure(serverError, nil)
                return
            }
            
            do {
                let decoded = try self.decoder.decode(requestObject.self, from: data!)
                completeClosure(nil, decoded)
            }
            catch {
                completeClosure(error, nil)
            }
        }
        return task
    }
    

    private func checkError(from response:URLResponse) -> APIError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil;
        }
        
        if !(200 ... 299 ~= httpResponse.statusCode) {
            return APIError.wrongStatusCode(httpResponse.statusCode)
        }
        return nil
    }
}
