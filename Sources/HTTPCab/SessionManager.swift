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
  
  @available(OSX 10.11, *)
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
  
  @available(OSX 10.11, *)
  @available(iOS 9.0, *)
  func cancelAllTasks() {
    session.getAllTasks { $0.forEach { $0.cancel() } }
  }
}

public extension SessionManager {
  func dataRequest(_ request: URLRequest) -> URLSessionDataTask {
    return session.dataTask(with: request).response { [weak self] _, _, error in
      self?.handle(error)
    }
  }
  
  func downloadRequest(_ request: URLRequest) -> URLSessionDownloadTask {
    return session.downloadTask(with: request).response { [weak self] _, _, error in
      self?.handle(error)
    }
  }
  
  func uploadRequest(_ streamedRequest: URLRequest) -> URLSessionUploadTask {
    return session.uploadTask(withStreamedRequest: streamedRequest).response { [weak self] _, _, error in
      self?.handle(error)
    }
  }
  
  func uploadRequest(_ request: URLRequest, fromFile url: URL) -> URLSessionUploadTask {
    return session.uploadTask(with: request, fromFile: url).response { [weak self] _, _, error in
      self?.handle(error)
    }
  }
}

private extension SessionManager {
  func handle(_ error: Error?) {
    guard let error = error else { return }
    self.delegate?.sessionManager(self, handlerFor: error)?(error)
  }
}
