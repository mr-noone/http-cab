//
//  Encoding.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

private enum StandardHeaderFieldKey: String {
  case contentType = "Content-Type"
}

private enum EncodingHeaderValue: String {
  case urlEncoding = "application/x-www-form-urlencoded; charset=utf-8"
  case jsonEncoding = "application/json"
  case plistEncoding = "application/x-plist"
}

public protocol ParametersEncoding {
  func encodeUrlRequest(_ urlRequest: URLRequest, withParameters parameters: Parameters?) throws -> URLRequest
}

public struct URLEncoding: ParametersEncoding {
  public static let `default` = URLEncoding()
  
  public func encodeUrlRequest(_ urlRequest: URLRequest, withParameters parameters: Parameters?) throws -> URLRequest {
    var urlRequest = urlRequest
    
    guard let url = urlRequest.url else {
      throw HTTPCabError.parametersEncodingError(error: .noUrl)
    }
    
    guard let params = parameters, !params.isEmpty else {
      return urlRequest
    }
    
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    urlComponents?.queryItems = params.map { URLQueryItem(paramKey: "\($0.key)", paramValue: "\($0.value)") }
    urlRequest.url = urlComponents?.url
        
    return urlRequest
  }
}

public struct JSONEncoding: ParametersEncoding {
  public static let `default` = JSONEncoding()
  
  public func encodeUrlRequest(_ urlRequest: URLRequest, withParameters parameters: Parameters?) throws -> URLRequest {
    var urlRequest = urlRequest
    
    do {
      guard let params = parameters, !params.isEmpty else {
        return urlRequest
      }
      if JSONSerialization.isValidJSONObject(params) {
        let data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        urlRequest.httpBody = data
        
        urlRequest.setValueForHeaderFieldIfNotConsist(StandardHeaderFieldKey.contentType.rawValue, value: EncodingHeaderValue.jsonEncoding.rawValue)
      } else {
        throw HTTPCabError.parametersEncodingError(error: .invalidJSON)
      }
    } catch {
      throw HTTPCabError.parametersEncodingError(error: .jsonSerializationError(error: error))
    }
    
    return urlRequest
  }
}

public struct PlistEncoding: ParametersEncoding {
  public static var xmlFormat: PlistEncoding {
    return PlistEncoding(pListFormat: .xml)
  }
  
  public static var binaryFormat: PlistEncoding {
    return PlistEncoding(pListFormat: .binary)
  }
  
  public static var openStepFormat: PlistEncoding {
    return PlistEncoding(pListFormat: .openStep)
  }
  
  public let pListFormat: PropertyListSerialization.PropertyListFormat
  public let writeOptions: PropertyListSerialization.WriteOptions
  
  
  public init(pListFormat: PropertyListSerialization.PropertyListFormat, writeOptions: PropertyListSerialization.WriteOptions = 0) {
    self.pListFormat = pListFormat
    self.writeOptions = writeOptions
  }
  
  public func encodeUrlRequest(_ urlRequest: URLRequest, withParameters parameters: Parameters?) throws -> URLRequest {
    var urlRequest = urlRequest
    
    guard let params = parameters, !params.isEmpty else { return urlRequest }
    
    do {
      let data = try PropertyListSerialization.data(fromPropertyList: params, format: pListFormat, options: writeOptions)
      
      urlRequest.httpBody = data
      urlRequest.setValueForHeaderFieldIfNotConsist(StandardHeaderFieldKey.contentType.rawValue, value: EncodingHeaderValue.plistEncoding.rawValue)
    } catch {
      throw HTTPCabError.parametersEncodingError(error: .pListEncodingError(error: error))
    }
    
    return urlRequest
  }
}

private extension URLRequest {
  mutating func setValueForHeaderFieldIfNotConsist(_ headerField: String, value: String) {
    if self.value(forHTTPHeaderField: headerField) == nil {
      self.setValue(value, forHTTPHeaderField: headerField)
    }
  }
}

public extension URLQueryItem {
  public init(paramKey: String, paramValue: Any) {
    self.init(name: paramKey, value: nil)
    
    switch paramValue {
    case let bool as Bool:
      self.value = bool ? "1" : "0"
    default:
      self.value = "\(paramValue)"
    }
  }
}
