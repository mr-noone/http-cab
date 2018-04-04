//
//  URLSessionTask.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

private var TaskDelegateKey = "TaskDelegateKey"

extension URLSessionTask {
  var delegate: TaskDelegate {
    guard let delegate = objc_getAssociatedObject(self, &TaskDelegateKey) as? TaskDelegate else {
      let delegate = TaskDelegate()
      objc_setAssociatedObject(self, &TaskDelegateKey, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
      return delegate
    }
    return delegate
  }
}

public extension URLSessionDataTask {
  @discardableResult
  func response(_ closure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Self {
    delegate.response(closure)
    return self
  }
}
