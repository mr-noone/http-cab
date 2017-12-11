//
//  ProviderConfiguration.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

public protocol ProviderConfiguration {
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var taskType: TaskType { get }
    var headers: HTTPHeaders? { get }
}

public enum TaskType {
    case plainRequest
    case requestWithData(Data)
    case requestWithParameters(params: Parameters, encoding: ParametersEncoding)
    case requestWithEncodableType(Encodable)
    case requestCombinedWithData(urlParams: Parameters, bodyParams: Data?)
    case requestCombinedWithBodyEncoding(urlParams: Parameters, body: Any, bodyEncoding: ParametersEncoding)
}
