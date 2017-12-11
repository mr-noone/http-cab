//
//  HTTPCabIntegrationTests.swift
//  HTTPCabIntegrationTests
//
//  Created by Igor Voytovich on 12/11/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import XCTest
@testable import HTTPCab

class RequestsTests: XCTestCase {
    let testUrl = URL(string: "https://apple.com")!
    
    var networkManager: NetworkManager!
    
    var requestsTimeout: TimeInterval {
        return networkManager.session.configuration.timeoutIntervalForRequest
    }
    
    override func setUp() {
        super.setUp()
        
        let urlConfiguration = URLSessionConfiguration.default
        urlConfiguration.timeoutIntervalForRequest = 15.0
        networkManager = NetworkManager(urlSessionConfiguration: urlConfiguration)
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testGetRequestWithURL() {
        let responseExpectation = self.expectation(description: "Expected get response from apple.com")
        
        networkManager.request(testUrl) { (_) in
            responseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: requestsTimeout, handler: nil)
    }
    
    func testGetRequestWithUrlRequest() {
        let responseExpectation = self.expectation(description: "Expected get response from apple.com")
        
        let urlRequest = URLRequest(url: testUrl)
        networkManager.request(urlRequest) { (_) in
            responseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: requestsTimeout, handler: nil)
    }
    
    func testPostRequestWithURL() {
        let responseExpectation = self.expectation(description: "Expected get response from apple.com")

        networkManager.request(testUrl, method: .post) { (_) in
            responseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: requestsTimeout, handler: nil)
    }
    
    func testPostRequestWithURLRequest() {
        let responseExpectation = self.expectation(description: "Expected get response from apple.com")

        let urlRequest = URLRequest(url: testUrl, method: .post)
        
        XCTAssertEqual(urlRequest.httpMethod, HTTPCab.Method.post.rawValue)
        
        networkManager.request(urlRequest) { (_) in
            responseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: requestsTimeout, handler: nil)
    }
}
