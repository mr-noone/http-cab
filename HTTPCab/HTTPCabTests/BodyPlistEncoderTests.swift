//
//  BodyPlistEncoderTests.swift
//  HTTPCabTests
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
import HTTPCab

class BodyPlistEncoderTests: XCTestCase {
  func testEncodeNilBody() {
    XCTAssertNil(BodyPlistEncoder().encode(nil))
  }
  
  func testEncodePlistObject() {
    XCTAssertNotNil(BodyPlistEncoder().encode(["key1": "value1"]))
  }
  
  func testEncodeInvalidJsonObject() {
    XCTAssertNil(BodyPlistEncoder().encode(NSObject()))
  }
}
