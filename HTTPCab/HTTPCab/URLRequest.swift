//
//  URLRequest.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

extension URLRequest {
  init(_ request: Request) {
    let url: URL = {
      var components = URLComponents(string: request.baseURL)
      components?.path = request.path
      components?.percentEncodedQuery = request.queryParams?.percentEncodedQuery
      guard
        let url = components?.url
      else {
        fatalError()
      }
      return url
    }()
    
    self.init(url: url)
    httpMethod = request.httpMethod.rawValue
    httpBody = request.encoder?.encode(request.body)
    httpBodyStream = request.bodyStream
    allHTTPHeaderFields = request.headers
  }
}

public extension URLRequest {
  init?(url: URL?, httpMethod: String) {
    guard let url = url else { return nil }
    self.init(url: url)
    self.httpMethod = httpMethod
  }
}
