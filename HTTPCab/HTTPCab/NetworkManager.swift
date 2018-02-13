//
//  HTTPManager.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public protocol NetworkManagerDelegate: class {
  func handler(for error: Error) -> ((Error) -> Void)?
}

public extension NetworkManagerDelegate {
  func handler(for error: Error) -> ((Error) -> Void)? { return nil }
}

open class NetworkManager {
  public weak var delegate: NetworkManagerDelegate?
  
  open static let `default`: NetworkManager = {
    return NetworkManager(urlSessionConfiguration: URLSessionConfiguration.default)
  }()
  
  var session: URLSession
  
  init(urlSessionConfiguration: URLSessionConfiguration = .default) {
    self.session = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
  }
  
  @discardableResult
  open func request(_ url: URL, method: Method = .get,
                    parameters: Parameters? = nil,
                    headers: HTTPHeaders? = nil,
                    parametersEncoding: ParametersEncoding = URLEncoding.default,
                    completion: @escaping RequestStatusCompletion) -> URLSessionDataTask? {
    let originalRequest = URLRequest(url: url, method: method, headers: headers)
    
    do {
      let encodedUrlRequest = try parametersEncoding.encodeUrlRequest(originalRequest, withParameters: parameters)
      return request(encodedUrlRequest, completion: completion)
    } catch {
      return nil
    }
  }
  
  @discardableResult
  open func request(_ urlRequest: URLRequest, completion: @escaping RequestStatusCompletion) -> URLSessionDataTask {
    let dataTask = session.dataTask(with: urlRequest) { data, response, error in
      guard let response = response as? HTTPURLResponse else { return }
      
      let error = error ?? HTTPError(code: response.statusCode)
      if let error = error {
        if let handler = self.delegate?.handler(for: error) {
          handler(error)
        } else {
          completion(.failure(error: error))
        }
      } else {
        completion(.success(value: RequestResult(response: response, data: data)))
      }
    }
    
    dataTask.resume()
    return dataTask
  }
}

