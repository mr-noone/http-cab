//
//  Data.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 3/21/19.
//  Copyright © 2019 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

extension Data {
  mutating func append(_ string: String) {
    append(string.data(using: .utf8) ?? Data())
  }
}
