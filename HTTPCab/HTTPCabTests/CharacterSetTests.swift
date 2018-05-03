//
//  CharacterSetTests.swift
//  HTTPCabTests
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import HTTPCab

class CharacterSetTests: XCTestCase {
  func testUrlQueryReserved() {
    XCTAssertEqual(CharacterSet.urlQueryReserved, CharacterSet(charactersIn: "!*'();:@&=+$,/?#[]"))
  }
  
  func testUrlQueryPercentEncoding() {
    let charSet = CharacterSet.urlQueryAllowed.subtracting(CharacterSet.urlQueryReserved)
    XCTAssertEqual(CharacterSet.urlQueryPercentEncoding, charSet)
  }
}
