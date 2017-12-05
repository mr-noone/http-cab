//
//  Encoding.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

private enum StandardHeaderFieldKey: String {
    case contentType = "Content-Type"
}

private enum EncodingHeaderValue: String {
    case urlEncoding = "application/x-www-form-urlencoded; charset=utf-8"
    case jsonEncoding = "application/json"
}

public protocol ParametersEncoding {
    func encodeUrlRequest(_ urlRequest: URLRequest, withParameters parameters: Parameters?) throws -> URLRequest
}

public struct URLEncoding: ParametersEncoding {
    public static let `default` = URLEncoding()
    
    public func encodeUrlRequest(_ urlRequest: URLRequest, withParameters parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let url = urlRequest.url else {
            throw HTTPCabError.parametersEncodingError(error: .noUrl)
        }
        
        guard let params = parameters, !params.isEmpty else {
            return urlRequest
        }
        
        if urlRequest.value(forHTTPHeaderField: StandardHeaderFieldKey.contentType.rawValue) == nil {
            urlRequest.setValue(EncodingHeaderValue.urlEncoding.rawValue, forHTTPHeaderField: StandardHeaderFieldKey.contentType.rawValue)
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = params.map { URLQueryItem(name: "\($0.key)", value: "\($0.value)") }
        urlRequest.url = urlComponents?.url
        
        return urlRequest
    }
}

public struct JSONEncoding: ParametersEncoding {
    public static let `default` = JSONEncoding()

    public func encodeUrlRequest(_ urlRequest: URLRequest, withParameters parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest
        do {
            guard let params = parameters, !params.isEmpty else {
                return urlRequest
            }
            let data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            urlRequest.httpBody = data
            
            if urlRequest.value(forHTTPHeaderField: StandardHeaderFieldKey.contentType.rawValue) == nil {
                urlRequest.setValue(EncodingHeaderValue.jsonEncoding.rawValue, forHTTPHeaderField: StandardHeaderFieldKey.contentType.rawValue)
            }
        } catch {
            throw HTTPCabError.parametersEncodingError(error: .jsonSerializationError(error: error))
        }
        
        return urlRequest
    }
}
