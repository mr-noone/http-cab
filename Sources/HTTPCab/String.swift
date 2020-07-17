//
//  String.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

extension String {
  var urlQueryPercentEncoded: String {
    return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryPercentEncoding) ?? ""
  }
}
