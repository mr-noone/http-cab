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
      components?.percentEncodedQuery = request.parameters?.percentEncodedQuery
      guard
        let url = components?.url
      else {
        fatalError()
      }
      return url
    }()
    
    self.init(url: url)
    httpBody = request.encoder?.encode(request.body)
    httpBodyStream = request.bodyStream
    allHTTPHeaderFields = request.headers
  }
}
