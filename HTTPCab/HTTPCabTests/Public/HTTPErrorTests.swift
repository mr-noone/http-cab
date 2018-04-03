//
//  HTTPErrorTests.swift
//  HTTPCabTests
//
//  Created by Aleksey Zgurskiy on 04.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import HTTPCab

class HTTPErrorTests: XCTestCase {
  func testInitWithSuccessCode() {
    XCTAssertNil(HTTPError(code: 200), "Should be nil if code is not in the range 400...599")
  }
  
  func testInitWithErrorCode() {
    for code in 400...599 {
      XCTAssertNotNil(HTTPError(code: code), "Should be not nil if code: \(code)")
    }
  }
  
  func testInitWithHttpResponseWithSuccessCode() {
    let url = URL(string: "https://google.com")!
    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    XCTAssertNil(HTTPError(response), "Should be nil if response code is not in the range 400...599")
  }
  
  func testInitWirhHttpResponseWithErrorCode() {
    let url = URL(string: "https://google.com")!
    let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
    XCTAssertNotNil(HTTPError(response), "Should be not nil if code is in range 400...599")
  }
}
