//
//  RequestableType.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

public protocol RequestableType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var taskType: TaskType { get }
    var headers: HTTPHeaders? { get }
}

public enum TaskType {
    case plainRequest
    case requestWithData(Data)
    case requestWithParametrs(params: Parameters, encoding: ParametersEncoding)
    case requestWithEncodableType(Encodable)
}
