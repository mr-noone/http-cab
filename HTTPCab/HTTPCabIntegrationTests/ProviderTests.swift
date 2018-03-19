//
//  ProviderTests.swift
//  HTTPCabIntegrationTests
//
//  Created by Igor Voytovich on 12/11/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import XCTest
@testable import HTTPCab

class ProviderTests: XCTestCase {
    let testUrl = URL(string: "https://apple.com")!
    var testProvider: RequestConfigurator<Requests>!
    
    let testParams = ["key1": "value1", "key2": "value2"]
    
    
    var requestsTimeout: TimeInterval {
        return testProvider.networkManager.session.configuration.timeoutIntervalForRequest
    }
    
    override func setUp() {
        super.setUp()
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 15.0
        let networkManager = NetworkManager(urlSessionConfiguration: sessionConfiguration)
        testProvider = RequestConfigurator<Requests>(networkManager: networkManager)
    }
    
    override func tearDown() {
        testProvider = nil
        super.tearDown()
    }
    
    func testProviderConfiguratorIsExist() {
        class TestProvider: Provider {
            typealias RequestsType = Requests
        }
        
        let provider = TestProvider()
        XCTAssertNotNil(provider.configurator)
    }
    
    func testProviderGetRequest() {
        let responseExpectation = self.expectation(description: "Expected get response from apple.com")
        
        let dataTask = testProvider.request(.getFromApple) { (_) in
            responseExpectation.fulfill()
        }
        
        XCTAssertNotNil(dataTask)
        
        waitForExpectations(timeout: requestsTimeout, handler: nil)
    }
    
    func testProviderPostRequest() {
        let responseExpectation = self.expectation(description: "Expected get response from apple.com")
        
        let dataTask = testProvider.request(.postToApple) { (_) in
            responseExpectation.fulfill()
        }
        
        XCTAssertNotNil(dataTask)
        
        waitForExpectations(timeout: requestsTimeout, handler: nil)
    }
    
    func testProviderRequestWithData() {
        let data = "teststr".data(using: String.Encoding.utf8)!
        let dataTask = testProvider.request(.postToAppleWithData(data)) {_ in }
        
        XCTAssertNotNil(dataTask?.originalRequest?.httpBody)
    }
    
    func testProviderRequestWithParameters() {
        let dataTask = testProvider.request(.postToAppleWithParams(params: testParams)) {_ in}
        
        var urlComponents = URLComponents(url: testUrl, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = testParams.map { URLQueryItem(paramKey: $0.key, paramValue: $0.value) }
        
        XCTAssertEqual(dataTask?.originalRequest?.url, urlComponents?.url)
    }
    
    func testProviderRequestWithEncodableType() {
        struct EncodableStruct: Encodable {}
        
        let testEncodableObject = EncodableStruct()
        
        let dataTask = testProvider.request(.postToAppleWithEncodable(encodableObject: testEncodableObject)) {_ in}
        
        XCTAssertNotNil(dataTask?.originalRequest?.httpBody)
    }
    
    func testProviderRequestCombinedWithData() {
        let dataTask = testProvider.request(.postToAppleWithUrlParamsAndData(urlParams: testParams, data: testParams.jsonEncoded())) {_ in}
        
        var urlComponents = URLComponents(url: testUrl, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = testParams.map { URLQueryItem(paramKey: $0.key, paramValue: $0.value) }
        
        XCTAssertEqual(dataTask?.originalRequest?.url, urlComponents?.url)
        XCTAssertNotNil(dataTask?.originalRequest?.httpBody)
    }
    
    func testProviderRequestCombinedWithBodyEncoding() {
        let dataTask = testProvider.request(.postToAppleWithBodyEncoding(urlParams: testParams, body: testParams)) {_ in}
        
        var urlComponents = URLComponents(url: testUrl, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = testParams.map { URLQueryItem(paramKey: $0.key, paramValue: $0.value) }
        
        XCTAssertEqual(dataTask?.originalRequest?.url, urlComponents?.url)
        XCTAssertNotNil(dataTask?.originalRequest?.httpBody)
    }
}
