//
//  RequestResultTests.swift
//  HTTPCabTests
//
//  Created by Igor Voytovich on 12/13/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import XCTest
@testable import HTTPCab

class RequestResultTests: XCTestCase {
  
  var testRequestResult: RequestResult!
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testDataMapJSON() {
    let testArray = [1, 2, 3, 4]
    let jsonArray = testArray.jsonEncoded()
    let response = HTTPURLResponse()
    let testRequestResult = RequestResult(response: response, data: jsonArray)
    
    XCTAssertNoThrow(try testRequestResult.toJSON())
    
    let decodedJSON = try! testRequestResult.toJSON()
    XCTAssertEqual(decodedJSON as! [Int], testArray)
  }
  
  func testDataMapEncodable() {
    struct DecodableStruct: Codable {
      var name: String
    }
    
    let testStruct = DecodableStruct(name: "John")
    
    XCTAssertNoThrow(try JSONEncoder().encode(testStruct))
    let data = try! JSONEncoder().encode(testStruct)
    let response = HTTPURLResponse()
    
    let testRequestResultWithDecodable = RequestResult(response: response, data: data)
    
    XCTAssertNoThrow(try testRequestResultWithDecodable.decodeJSONObject(DecodableStruct.self))
  }
}