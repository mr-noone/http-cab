//
//  ProviderTesting.swift
//  Example
//
//  Created by Igor Voytovich on 12/7/17.
//  Copyright © 2017 NullGR. All rights reserved.
//

import Foundation
import HTTPCab

enum Requests {
    case getPosts
}

extension Requests: RequestableType {
    var baseURL: URL {
        return URL(string: "http://localhost:3000/")!
    }
    
    var path: String {
        return "posts"
    }
    
    var taskType: TaskType {
        return .requestWithParametrs(params: ["author" : "Max", "title" : "Maximus"], encoding: JSONEncoding.default)
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var method: HTTPCab.Method {
        return .post
    }
}

class RequestsProvider: NetworkService {
    typealias ApiProviderType = Requests
    
    func request() {
        provider.request(.getPosts) { (responseStatus) in
            switch responseStatus {
            case .success(value: let result):
                print(try! result.mapJSON())
            case .failure(error: let error):
                print(error)
            }
        }
    }
}
