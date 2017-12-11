//
//  HTTPCab.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public enum Method: String {
    case get = "GET"
    case post = "POST"
    case head = "HEAD"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
    case options = "OPTIONS"
}

public typealias RequestStatusCompletion = (RequestStatus) -> ()
public typealias DataTask = URLSessionDataTask

@discardableResult
public func request(_ url: URL, method: Method = .get,
                  parameters: Parameters? = nil,
                  headers: HTTPHeaders? = nil,
                  parametersEncoding: ParametersEncoding = URLEncoding.default,
                  completion: @escaping RequestStatusCompletion) -> DataTask? {
    return NetworkManager.default.request(url, method: method, parameters: parameters, headers: headers, parametersEncoding: parametersEncoding, completion: completion)
}

public enum RequestStatus {
    case success(value: RequestResult)
    case failure(error: Error)
}

extension URLRequest {
    public init(url: URL, method: Method, headers: HTTPHeaders? = nil) {
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach {
                setValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
    }
}

