//
//  Provider.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public protocol Provider {
  associatedtype RequestType = Request
  var sessionManager: SessionManager { get }
  
  func dataRequest(_ request: () -> RequestType) -> URLSessionTask
  func dataRequest(_ request: () -> URLRequest) -> URLSessionTask
}

public extension Provider {
  var sessionManager: SessionManager {
    return SessionManager.default
  }
  
  func dataRequest(_ request: () -> RequestType) -> URLSessionTask {
    let task = sessionManager.dataRequest(request() as! Request)
    task.resume()
    return task
  }
  
  func dataRequest(_ request: () -> URLRequest) -> URLSessionTask {
    let task = sessionManager.dataRequest(request())
    task.resume()
    return task
  }
}
