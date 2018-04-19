//
//  URLRequestTests.swift
//  HTTPCabTests
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import HTTPCab

private class UTRequest: Request {
  var baseURL: String = "https://domain.com"
  var path: String = "/path/to"
  var httpMethod: HTTPMethod = .get
}

class URLRequestTests: XCTestCase {
  func testInitWithRequest() {
    XCTAssertNotNil(URLRequest(UTRequest()))
  }
  
  func testInitWithHttpMethod() {
    XCTAssertNotNil(URLRequest(url: URL(string: "http://127.0.0.1"), httpMethod: "POST"))
  }
}
