//
//  EncodingTests.swift
//  HTTPCabTests
//
//  Created by Igor Voytovich on 12/11/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import XCTest
@testable import HTTPCab

class ParamsEncodingTests: XCTestCase {
    
    let testUrlRequest = URLRequest(url: URL(string: "https://apple.com")!)
    let testParams = ["Key1" : "Value1", "Key2" : "Value2"]
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEncoding() {
        XCTAssertNoThrow(try URLEncoding.default.encodeUrlRequest(testUrlRequest, withParameters: testParams))
        XCTAssertNoThrow(try JSONEncoding.default.encodeUrlRequest(testUrlRequest, withParameters: testParams))
        XCTAssertNoThrow(try PlistEncoding.xmlFormat.encodeUrlRequest(testUrlRequest, withParameters: testParams))
        XCTAssertNoThrow(try PlistEncoding.binaryFormat.encodeUrlRequest(testUrlRequest, withParameters: testParams))
    }
    
    func testEncodingErrorThrow() {
        let badDictionary = ["Key1" : NSObject()]
        
        let badRequest = NSMutableURLRequest()
        badRequest.url = URL(string: "")
        
        XCTAssertThrowsError(try URLEncoding.default.encodeUrlRequest(badRequest as URLRequest, withParameters: badDictionary))
        XCTAssertThrowsError(try JSONEncoding.default.encodeUrlRequest(testUrlRequest, withParameters: badDictionary))
        XCTAssertThrowsError(try PlistEncoding.xmlFormat.encodeUrlRequest(testUrlRequest, withParameters: badDictionary))
        XCTAssertThrowsError(try PlistEncoding.binaryFormat.encodeUrlRequest(testUrlRequest, withParameters: badDictionary))
    }
    
    func testEmptyParams() {
        let urlRequestFromJSONEncoding = try? JSONEncoding.default.encodeUrlRequest(testUrlRequest, withParameters: [:])
        let urlRequestFromURLEncoding = try? URLEncoding.default.encodeUrlRequest(testUrlRequest, withParameters: [:])
        let urlRequestFromPlistEncoding = try? PlistEncoding.xmlFormat.encodeUrlRequest(testUrlRequest, withParameters: [:])
        XCTAssertEqual(urlRequestFromJSONEncoding, testUrlRequest)
        XCTAssertEqual(urlRequestFromURLEncoding, testUrlRequest)
        XCTAssertEqual(urlRequestFromPlistEncoding, testUrlRequest)
    }
    
    func testURLQueryItem() {
        let testBoolDict = ["True" : true, "False" : false]
        let currentUrlQueryItems = testBoolDict.map { URLQueryItem(paramKey: $0, paramValue: $1) }
        
        currentUrlQueryItems.forEach { XCTAssertNotNil($0.value) }
        XCTAssertEqual(currentUrlQueryItems[0].value, "1")
        XCTAssertEqual(currentUrlQueryItems[1].value, "0")
    }
}
