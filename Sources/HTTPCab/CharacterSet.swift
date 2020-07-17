//
//  CharacterSet.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

extension CharacterSet {
  static var urlQueryReserved: CharacterSet {
    return CharacterSet(charactersIn: "!*'();:@&=+$,/?#[]")
  }
  
  static var urlQueryPercentEncoding: CharacterSet {
    return CharacterSet.urlQueryAllowed.subtracting(CharacterSet.urlQueryReserved)
  }
}
