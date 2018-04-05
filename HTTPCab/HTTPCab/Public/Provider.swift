//
//  Provider.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public protocol Provider {
  var sessionManager: SessionManager { get }
  
  func dataRequest(_ request: () -> Request) -> URLSessionDataTask
  func dataRequest(_ url: () -> URL) -> URLSessionDataTask
  func dataRequest(_ request: () -> URLRequest) -> URLSessionDataTask
  
  func downloadRequest(_ request: () -> Request) -> URLSessionDownloadTask
  func downloadRequest(_ url: () -> URL) -> URLSessionDownloadTask
  func downloadRequest(_ request: () -> URLRequest) -> URLSessionDownloadTask
}

public extension Provider {
  var sessionManager: SessionManager {
    return SessionManager.default
  }
  
  @discardableResult
  func dataRequest(_ request: () -> Request) -> URLSessionDataTask {
    return dataRequest { URLRequest(request()) }
  }
  
  @discardableResult
  func dataRequest(_ url: () -> URL) -> URLSessionDataTask {
    return dataRequest { URLRequest(url: url()) }
  }
  
  @discardableResult
  func dataRequest(_ request: () -> URLRequest) -> URLSessionDataTask {
    let task = sessionManager.dataRequest(request())
    task.resume()
    return task
  }
  
  @discardableResult
  func downloadRequest(_ request: () -> Request) -> URLSessionDownloadTask {
    return downloadRequest { URLRequest(request()) }
  }
  
  @discardableResult
  func downloadRequest(_ url: () -> URL) -> URLSessionDownloadTask {
    return downloadRequest { URLRequest(url: url()) }
  }
  
  @discardableResult
  func downloadRequest(_ request: () -> URLRequest) -> URLSessionDownloadTask {
    let task = sessionManager.downloadRequest(request())
    task.resume()
    return task
  }
}
