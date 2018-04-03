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
  var baseURL: String { return "https://domain.com" }
  var path: String { return "/path/to" }
  var method: HTTPCab.Method { return .get }
  var parameters: [String : String]? { return nil }
  var body: Any? { return nil }
  var encoder: BodyEncoder? { return nil }
  var headers: [String : String]? { return nil }
}

class URLRequestTests: XCTestCase {
  func testInitWithRequest() {
    XCTAssertNotNil(URLRequest(UTRequest()))
  }
}
