//
//  Array.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 3/21/19.
//  Copyright © 2019 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

extension Array where Array.Element == Data {
  func joined() -> Data {
    var data = Data()
    forEach { data.append($0) }
    return data
  }
}

extension Array {
  func map<T>(_ transform: (Element, Int) throws -> T) rethrows -> [T] {
    var result = [T]()
    for (index, obj) in enumerated() {
      result.append(try transform(obj, index))
    }
    return result
  }
  
  func compactMap<T>(_ transform: (Element, Int) throws -> T?) rethrows -> [T] {
    var result = [T]()
    for (index, obj) in enumerated() {
      if let newObj = try transform(obj, index) {
        result.append(newObj)
      }
    }
    return result
  }
}
