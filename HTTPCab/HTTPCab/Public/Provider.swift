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
  
  func dataRequest(_ request: () -> RequestType) -> URLSessionDataTask
  func dataRequest(_ url: () -> URL) -> URLSessionDataTask
  func dataRequest(_ request: () -> URLRequest) -> URLSessionDataTask
}

public extension Provider {
  var sessionManager: SessionManager {
    return SessionManager.default
  }
  
  @discardableResult
  func dataRequest(_ request: () -> RequestType) -> URLSessionDataTask {
    let task = sessionManager.dataRequest(request() as! Request)
    task.resume()
    return task
  }
  
  @discardableResult
  func dataRequest(_ url: () -> URL) -> URLSessionDataTask {
    let task = sessionManager.dataRequest(url())
    task.resume()
    return task
  }
  
  @discardableResult
  func dataRequest(_ request: () -> URLRequest) -> URLSessionDataTask {
    let task = sessionManager.dataRequest(request())
    task.resume()
    return task
  }
}
