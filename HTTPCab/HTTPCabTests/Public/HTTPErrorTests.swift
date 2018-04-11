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
  let url = URL(string: "https://google.com")!
  
  func testInitWithSuccessCode() {
    XCTAssertNil(HTTPError(code: 200), "Should be nil if code is not in the range 400...599")
  }
  
  func testInitWithErrorCode() {
    for code in 400...599 {
      XCTAssertNotNil(HTTPError(code: code), "Should be not nil if code: \(code)")
    }
  }
  
  func testInitWithHttpResponseWithSuccessCode() {
    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    XCTAssertNil(HTTPError(response), "Should be nil if response code is not in the range 400...599")
  }
  
  func testInitWirhHttpResponseWithErrorCode() {
    let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
    XCTAssertNotNil(HTTPError(response), "Should be not nil if code is in range 400...599")
  }
  
  func testInitWithUserInfoJsonData() {
    let key = "key"
    let value = "value"
    
    let data = "{\"\(key)\":\"\(value)\"}".data(using: .utf8)
    let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
    let error = HTTPError(response, data: data)
    XCTAssertEqual(error?.userInfo[key] as? String, value)
  }
  
  func testInitWithUserInfoStringData() {
    let value = "value"
    let data = "\(value)".data(using: .utf8)
    let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
    let error = HTTPError(response, data: data)
    XCTAssertEqual(error?.userInfo[HTTPError.HTTPErrorDescription] as? String, value)
  }
  
  func testInitWithUserInfoBinaryData() {
    let data = Data(base64Encoded: """
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAAJNJREFUOI2t0zEKwkAQBdC3IaSyt1b0Bl5Gb2Fp5wE8ga2dFzF4AwuxFUuxCBLBQkEJCks2vxzmP5hiAgJGPqlxEpkcMwy+ZldscY4FJpg35osG+i/rHJc39J0VighgGbDBPWL5VwrYtSzDPsMjAaizhDLoBCgT+mWGKgGoOjnhlgr0E/q9gCnGLYFD8HrnYUvg+ATcMhUUmzMIcQAAAABJRU5ErkJggg==
""")
    let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
    let error = HTTPError(response, data: data)
    XCTAssertNotNil(error)
    XCTAssertNil(error?.userInfo[HTTPError.HTTPErrorDescription])
  }
}
