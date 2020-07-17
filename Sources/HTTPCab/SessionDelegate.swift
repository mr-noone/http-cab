//
//  SessionDelegate.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

final class SessionDelegate: NSObject, URLSessionTaskDelegate {
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    task.delegate.urlSession(session, task: task, didCompleteWithError: error)
  }
}

extension SessionDelegate: URLSessionDataDelegate {
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    dataTask.delegate.urlSession(session, dataTask: dataTask, didReceive: data)
  }
}

extension SessionDelegate: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    downloadTask.delegate.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
  }
}
