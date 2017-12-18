//
//  TaskTests.swift
//  HTTPCabTests
//
//  Created by Igor Voytovich on 12/13/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import XCTest
@testable import HTTPCab

class TaskTests: XCTestCase {
    
    var testTask: Task<Requests>!

    override func setUp() {
        super.setUp()
        
        testTask = Task(url: "https://apple.com", method: .get, taskType: .plainRequest, headers: nil)
    }
    
    override func tearDown() {
        testTask = nil
        super.tearDown()
    }
    
    func testTaskRequiredInfo() {
        XCTAssertNotNil(testTask.url)
        XCTAssertNotNil(testTask.taskType)
        XCTAssertNotNil(testTask.method)
    }
    
    func testTaskConvertionToUrlRequest() {
        XCTAssertNoThrow(try testTask.urlRequest())
    }
    
    func testInvalidTaskConvertion() {
        let invalidTask: Task<Requests> = Task(url: "", method: .get, taskType: .plainRequest, headers: nil)
        XCTAssertThrowsError(try invalidTask.urlRequest())
    }
}
