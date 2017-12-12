//
//  EncodingTests.swift
//  HTTPCabTests
//
//  Created by Igor Voytovich on 12/11/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import XCTest
@testable import HTTPCab

class BodyEncodingTests: XCTestCase {
    
    let testArray = ["Value1", "Value2", "Value3"]
    let testDictionary = ["Key1": "Value1", "Key2": "Value2", "Key3": "Value3"]
    let testString = "TestString"
    
    func testJSONEncoding() {
        let jsonEncodedArray = testArray.jsonEncoded()
        let jsonEncodedDictionary = testDictionary.jsonEncoded()
        
        XCTAssertNotNil(jsonEncodedArray)
        XCTAssertNotNil(jsonEncodedDictionary)
    }
    
    func testPlainTestEncoding() {
        let encodedString = testString.data(using: String.Encoding.utf8)
        
        XCTAssertNotNil(encodedString)
    }
    
    func testPlistEncoding() {
        let plistEncodedArrayXML = testArray.plistEncodedWithPlistFormat(.xml)
        let plistEncodedArrayBinary = testArray.plistEncodedWithPlistFormat(.binary)
        
        XCTAssertNotNil(plistEncodedArrayXML)
        XCTAssertNotNil(plistEncodedArrayBinary)
        
        let plistEncodedDictionaryXML = testDictionary.plistEncodedWithPlistFormat(.xml)
        let plistEncodedDictionaryBinary = testDictionary.plistEncodedWithPlistFormat(.binary)
        
        XCTAssertNotNil(plistEncodedDictionaryXML)
        XCTAssertNotNil(plistEncodedDictionaryBinary)
    }
    
    func testDictionaryFormURLEncoding() {
        let formUrlEncodedDictionary = testDictionary.formUrlEncoded()
        XCTAssertNotNil(formUrlEncodedDictionary)
        
        if let data = formUrlEncodedDictionary, let encodedString = String(data: data, encoding: String.Encoding.utf8) {
            let expectedEncodedString = (testDictionary.flatMap { "\($0.key)=\($0.value)"} as Array).joined(separator: "&")
            XCTAssertEqual(encodedString, expectedEncodedString)
        }
    }
}
