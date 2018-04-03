//
//  Dictionary.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringProtocol, Value: StringProtocol {
  var percentEncodedQuery: String {
    return compactMap {
      guard
        let key = $0.key as? String,
        let value = $0.value as? String
      else {
        return nil
      }
      return "\(key.urlQueryPercentEncoded)=\(value.urlQueryPercentEncoded)"
    }.joined(separator: "&")
  }
}
