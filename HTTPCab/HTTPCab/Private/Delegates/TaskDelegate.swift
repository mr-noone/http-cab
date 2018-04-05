//
//  TaskDelegate.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

final class TaskDelegate: NSObject {
  var data: Data?
  var url: URL?
  var response: URLResponse?
  var error: Error?
  
  let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.isSuspended = true
    return queue
  }()
}

extension TaskDelegate {
  func response(_ closure: @escaping (Data?, URLResponse?, Error?) -> Void) {
    queue.addOperation {
      DispatchQueue.main.async {
        closure(self.data, self.response, self.error)
      }
    }
  }
  
  func response(_ closure: @escaping (URL?, URLResponse?, Error?) -> Void) {
    queue.addOperation {
      DispatchQueue.main.async {
        closure(self.url, self.response, self.error)
      }
    }
  }
}

extension TaskDelegate: URLSessionTaskDelegate {
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    if
      let response = response as? HTTPURLResponse,
      let error = HTTPError(response, data: data) {
      self.error = error
    } else {
      self.error = error
    }
    
    queue.isSuspended = false
  }
}

extension TaskDelegate: URLSessionDataDelegate {
  func urlSession(_ session: URLSession,
                  dataTask: URLSessionDataTask,
                  didReceive response: URLResponse,
                  completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    self.response = response
    completionHandler(.allow)
  }
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    if let _ = self.data {
      self.data?.append(data)
    } else {
      self.data = data
    }
  }
}

extension TaskDelegate: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    self.url = location
  }
}
