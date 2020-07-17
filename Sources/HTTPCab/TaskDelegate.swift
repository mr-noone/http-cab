//
//  TaskDelegate.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

final class TaskDelegate: NSObject {
  private var data: Data?
  private var url: URL?
  private var error: Error?
  private var response: URLResponse?
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.isSuspended = true
    return queue
  }()
  
  deinit {
    guard let url = self.url else { return }
    try? FileManager.default.removeItem(at: url)
  }
}

extension TaskDelegate {
  func response(_ closure: @escaping (Data?, URLResponse?, Error?) -> Void) {
    queue.addOperation {
      DispatchQueue.main.async {
        closure(self.error == nil ? self.data : nil, self.response, self.error)
      }
    }
  }
  
  func response(_ closure: @escaping (URL?, URLResponse?, Error?) -> Void) {
    queue.addOperation {
      DispatchQueue.main.async {
        closure(self.error == nil ? self.url : nil, self.response, self.error)
      }
    }
  }
}

extension TaskDelegate: URLSessionTaskDelegate {
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    self.response = task.response
    if
      let response = task.response as? HTTPURLResponse,
      let error = HTTPError(response, data: data) {
      self.error = error
    } else {
      self.error = error
    }
    
    queue.isSuspended = false
  }
}

extension TaskDelegate: URLSessionDataDelegate {
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
    let fileManager = FileManager.default
    
    var fileUrl: URL
    if #available(OSX 10.12, *), #available(iOS 10.0, *), #available(watchOS 3.0, *) {
      fileUrl = fileManager.temporaryDirectory
    } else {
      fileUrl = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    }
    
    fileUrl.appendPathComponent(UUID().uuidString)
    fileUrl.appendPathExtension((downloadTask.response?.suggestedFilename as NSString?)?.pathExtension ?? "")
    
    do {
      try fileManager.copyItem(at: location, to: fileUrl)
    } catch {
      self.error = error
    }
    
    url = fileUrl
  }
}
