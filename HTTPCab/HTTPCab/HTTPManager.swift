//
//  HTTPManager.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

open class HTTPManager {
    
    open static let `default`: HTTPManager = {
        return HTTPManager(urlSessionConfiguration: URLSessionConfiguration.default)
    }()
    
    var session: URLSession
    var delegate: SessionDelegate
    
    init(urlSessionConfiguration: URLSessionConfiguration = .default, sessionDelegate: SessionDelegate = SessionDelegate()) {
        self.session = URLSession(configuration: urlSessionConfiguration, delegate: sessionDelegate, delegateQueue: nil)
        self.delegate = sessionDelegate
    }
    
    open func request(_ url: URL, method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      headers: HTTPHeaders? = nil,
                      parametersEncoding: ParametersEncoding = URLEncoding.default,
                      completion: @escaping (ResponseStatus) -> ()) {
        let originalRequest = URLRequest(url: url, method: method, headers: headers)
        
        do {
            let encodedUrlRequest = try parametersEncoding.encodeUrlRequest(originalRequest, withParameters: parameters)
            let dataTask = session.dataTask(with: encodedUrlRequest) { data, urlResponse, error in
                if let error = error {
                    completion(.failure(error: error))
                }
                
                guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                    return
                }
                
                completion(.success(value: ResponseResult(statusCode: httpUrlResponse.statusCode, data: data)))
            }
            
            dataTask.resume()
        } catch {
            
        }
    }
}

public struct ResponseResult {
    public let statusCode: Int
    public let data: Data?
    
    public func mapJSON() throws -> Any {
        guard let data = self.data else {
            throw HTTPCabError.responseError(error: .noData)
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            throw HTTPCabError.responseError(error: .jsonSerializationError(error: error))
        }
    }
}

