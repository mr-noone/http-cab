//
//  HTTPCab.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case head    = "HEAD"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
    case options = "OPTIONS"
}

struct ResponseResult {
    let statusCode: Int
    let data: Data?
}

enum ResponseStatus {
    case success(value: ResponseResult)
    case failure(error: Error)
}

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
                      parametersEncoding: ParametersEncoding = URLEncoding.default) {
        
        var originalRequest: URLRequest?
        do {
            originalRequest = URLRequest(url: url, method: method, headers: headers)
            let encodedUrlRequest = try parametersEncoding.encodeUrlRequest(originalRequest!, withParameters: parameters)
//            session.dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        } catch {
            
        }
        
    }
    
    
}

open class SessionDelegate: NSObject, URLSessionTaskDelegate {
    
}

extension URLRequest {
    public init(url: URL, method: HTTPMethod, headers: HTTPHeaders? = nil) {
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach {
                setValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
    }
}

