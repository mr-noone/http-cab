//
//  TestProvider.swift
//  HTTPCabIntegrationTests
//
//  Created by Igor Voytovich on 12/11/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation
@testable import HTTPCab

class TestProvider: Provider {
    typealias RequestsType = Requests
    
    func getRequestFromApple(completion: @escaping RequestStatusCompletion) {
        configurator.request(.getFromApple, completion: completion)
    }
    
    func postRequestToApple(completion: @escaping RequestStatusCompletion) {
        configurator.request(.postToApple, completion: completion)
    }
}

enum Requests {
    case getFromApple
    case postToApple
    case postToAppleWithData(Data)
    case postToAppleWithParams(params: [String : String])
    case postToAppleWithEncodable(encodableObject: Encodable)
    case postToAppleWithUrlParamsAndData(urlParams: [String : String], data: Data?)
    case postToAppleWithBodyEncoding(urlParams: [String : String], body: Any)
}

extension Requests: ProviderConfiguration {
    
    var baseURL: URL {
        return URL(string: "https://apple.com")!
    }
    
    var method: HTTPCab.Method {
        switch self {
        case .getFromApple:
            return .get
        case .postToApple,
             .postToAppleWithData(_),
             .postToAppleWithParams(params: _),
             .postToAppleWithEncodable(encodableObject: _),
             .postToAppleWithUrlParamsAndData(urlParams: _, data: _),
             .postToAppleWithBodyEncoding(urlParams: _, body: _):
            return .post
        }
    }
    
    var path: String {
        return ""
    }
    
    var taskType: TaskType {
        switch self {
        case .getFromApple,
             .postToApple:
            return .plainRequest
        case .postToAppleWithData(let data):
            return .requestWithData(data)
        case .postToAppleWithParams(params: let params):
            return .requestWithParameters(params: params, encoding: URLEncoding.default)
        case .postToAppleWithEncodable(encodableObject: let obj):
            return .requestWithEncodableType(obj)
        case .postToAppleWithUrlParamsAndData(urlParams: let urlParams, data: let data):
            return .requestCombinedWithData(urlParams: urlParams, bodyParams: data)
        case .postToAppleWithBodyEncoding(urlParams: let urlParams, body: let body):
            return .requestCombinedWithBodyEncoding(urlParams: urlParams, body: body, bodyEncoding: JSONEncoding.default)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
