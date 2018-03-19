//
//  Task.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/7/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

open class Task<T> {
  open let url: String
  open let method: Method
  open let taskType: TaskType
  open let headers: HTTPHeaders?
  
  public init(url: String, method: Method, taskType: TaskType, headers: HTTPHeaders?) {
    self.url = url
    self.method = method
    self.taskType = taskType
    self.headers = headers
  }
}

extension Task {
  public func urlRequest() throws -> URLRequest {
    guard let requestUrl = URL(string: url) else {
      throw HTTPCabError.mappingError(error: .requestMapping(url))
    }
    
    var request = URLRequest(url: requestUrl)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    
    switch taskType {
    case .plainRequest:
      return request
    case .requestWithData(let data):
      request.httpBody = data
      return request
    case .requestWithEncodableType(let encodable):
      return try request.encodeWithEncodable(encodable)
    case .requestWithParameters(params: let params, encoding: let encoding):
      return try request.encodeWithParameters(params, andParametersEncoding: encoding)
    case .requestCombinedWithData(urlParams: let urlParams, bodyParams: let bodyParams):
      var encodedRequest = try request.encodeWithParameters(urlParams, andParametersEncoding: URLEncoding.default)
      encodedRequest.httpBody = bodyParams
      return encodedRequest
    case .requestCombinedWithBodyEncoding(urlParams: let urlParams, body: let body, bodyEncoding: let bodyEncoding):
      var encodedRequest = try request.encodeWithParameters(urlParams, andParametersEncoding: URLEncoding.default)
      encodedRequest.httpBody = encodeAnyBody(body: body, encoding: bodyEncoding)
      return encodedRequest
    }
  }
  
  private func encodeAnyBody(body: Any, encoding: ParametersEncoding) -> Data? {
    switch body {
    case let array as [Any]:
      return array.encodeWithEncoding(encoding)
    case let dictionary as [String: Any]:
      return dictionary.encodeWithEncoding(encoding)
    case let string as String:
      return string.data(using: String.Encoding.utf8)
    case let data as Data:
      return data
    default:
      return nil
    }
  }
}
