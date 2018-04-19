//
//  StringTests.swift
//  HTTPCabTests
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import HTTPCab

class StringTests: XCTestCase {
  func testUrlQueryPercentEncoded() {
    let queryString = "!*'();:@&=+$,/?#[]"
    let resultString = "%21%2A%27%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%23%5B%5D"
    XCTAssertEqual(queryString.urlQueryPercentEncoded, resultString)
  }
}
