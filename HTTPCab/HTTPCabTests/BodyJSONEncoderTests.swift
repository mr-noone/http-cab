//
//  BodyJSONEncoderTests.swift
//  HTTPCabTests
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
import HTTPCab

class BodyJSONEncoderTests: XCTestCase {
  func testEncodeNilBody() {
    XCTAssertNil(BodyJSONEncoder().encode(nil))
  }
  
  func testEncodeJsonObject() {
    XCTAssertNotNil(BodyJSONEncoder().encode(["key": "value"]))
  }
  
  func testEncodeInvalidJsonObject() {
    XCTAssertNil(BodyJSONEncoder().encode(NSObject()))
  }
}
