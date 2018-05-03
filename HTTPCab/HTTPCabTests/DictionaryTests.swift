//
//  DictionaryTests.swift
//  HTTPCabTests
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import HTTPCab

class DictionaryTests: XCTestCase {
  func testPercentEncodedQuery() {
    let query = ["token!":"insje1823=+"]
    XCTAssertEqual(query.percentEncodedQuery, "token%21=insje1823%3D%2B")
  }
}
