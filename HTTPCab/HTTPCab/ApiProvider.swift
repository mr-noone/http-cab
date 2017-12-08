//
//  HTTPCabProvider.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public protocol NetworkService {
    associatedtype ApiProviderType: ProviderConfiguration
    var provider: ApiProvider<ApiProviderType> { get }
}

public extension NetworkService {
    var provider: ApiProvider<ApiProviderType> {
        return ApiProvider<ApiProviderType>()
    }
}

public class ApiProvider<T: ProviderConfiguration> {
    
    let requestManager: NetworkManager
    
    public init(requestManager: NetworkManager = NetworkManager.default) {
        self.requestManager = requestManager
    }
    
    @discardableResult
    public func request(_ target: T, completion: @escaping RequestStatusCompletion) -> URLSessionDataTask? {
        let endpoint = defaultEndpointForTarget(target)
        do {
            let urlRequest = try endpoint.urlRequest()
            return standartRequest(urlRequest: urlRequest, completion: completion)
        } catch {
            return nil
        }
    }
    
    private func standartRequest(urlRequest: URLRequest, completion: @escaping RequestStatusCompletion) -> URLSessionDataTask {
        return requestManager.request(urlRequest, completion: completion)
    }
}

public extension ApiProvider {
    public final func defaultEndpointForTarget(_ target: T) -> Endpoint<T> {
        return Endpoint(url: URL(requestable: target).absoluteString
            , method: target.method, taskType: target.taskType, headers: target.headers)
    }
}

public extension URL {
    init<T: ProviderConfiguration>(requestable: T) {
        if requestable.path.isEmpty {
            self = requestable.baseURL
        } else {
            self = requestable.baseURL.appendingPathComponent(requestable.path)
        }
    }
}

extension URLRequest {
    mutating func encodeWithParameters(_ parameters: Parameters, andParametersEncoding encoding: ParametersEncoding) throws -> URLRequest {
            return try encoding.encodeUrlRequest(self, withParameters: parameters)
    }
    
    mutating func encodeWithEncodable(_ encodable: Encodable) throws -> URLRequest {
        do {
            let obj = AnyEncodableObject(encodable)
            httpBody = try JSONEncoder().encode(obj)
            return self
        } catch {
            throw HTTPCabError.mappingError(error: .encodableMapping)
        }
    }
}
