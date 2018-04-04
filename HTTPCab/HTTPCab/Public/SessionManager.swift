//
//  SessionManager.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public protocol SessionManagerDelegate: class {
  func sessionManager(_ manager: SessionManager, handlerFor error: Error) -> ((Error) -> Void)?
}

public extension SessionManagerDelegate {
  func sessionManager(_ manager: SessionManager, handlerFor error: Error) -> ((Error) -> Void)? {
    return nil
  }
}

final public class SessionManager {
  private var session: URLSession
  private var sessionDelegate = SessionDelegate()
  
  public static let `default` = SessionManager()
  public weak var delegate: SessionManagerDelegate?
  
  public init(configuration: URLSessionConfiguration = .default, delegate: SessionManagerDelegate? = nil) {
    session = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: nil)
    self.delegate = delegate
  }
}

public extension SessionManager {
  func finishTasksAndInvalidate() {
    session.finishTasksAndInvalidate()
  }
  
  func flush(completionHandler: @escaping () -> Void) {
    session.flush(completionHandler: completionHandler)
  }
  
  func getTasksWithCompletionHandler(_ completionHandler: @escaping ([URLSessionDataTask], [URLSessionUploadTask], [URLSessionDownloadTask]) -> Void) {
    session.getTasksWithCompletionHandler(completionHandler)
  }
  
  @available(iOS 9.0, *)
  func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void) {
    session.getAllTasks(completionHandler: completionHandler)
  }
  
  func invalidateAndCancel() {
    session.invalidateAndCancel()
  }
  
  func reset(completionHandler: @escaping () -> Void) {
    session.reset(completionHandler: completionHandler)
  }
  
  @available(iOS 9.0, *)
  func cancelAllTasks() {
    session.getAllTasks { $0.forEach { $0.cancel() } }
  }
}

extension SessionManager {
  func dataRequest(_ request: Request) -> URLSessionDataTask {
    return dataRequest(URLRequest(request))
  }
  
  func dataRequest(_ url: URL) -> URLSessionDataTask {
    return dataRequest(URLRequest(url: url))
  }
  
  func dataRequest(_ request: URLRequest) -> URLSessionDataTask {
    return session.dataTask(with: request).response { [weak self] _, _, error in
      guard let error = error, let _self = self else { return }
      _self.delegate?.sessionManager(_self, handlerFor: error)?(error)
    }
  }
}
