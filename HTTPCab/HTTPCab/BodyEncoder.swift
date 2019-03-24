//
//  BodyEncoder.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public protocol BodyEncoder {
  var contentType: String { get }
  func encode(_ body: Any?) -> Data?
}

public struct BodyJSONEncoder: BodyEncoder {
  public var contentType: String { return "application/json" }
  public var options: JSONSerialization.WritingOptions
  
  public init(options: JSONSerialization.WritingOptions = .prettyPrinted) {
    self.options = options
  }
  
  public func encode(_ body: Any?) -> Data? {
    guard let body = body, JSONSerialization.isValidJSONObject(body) else { return nil }
    return try? JSONSerialization.data(withJSONObject: body, options: options)
  }
}

public struct BodyPlistEncoder: BodyEncoder {
  public var contentType: String { return "application/xml" }
  public let format: PropertyListSerialization.PropertyListFormat
  public let options: PropertyListSerialization.WriteOptions
  
  public init(format: PropertyListSerialization.PropertyListFormat = .xml,
              options: PropertyListSerialization.WriteOptions = 0) {
    self.format = format
    self.options = options
  }
  
  public func encode(_ body: Any?) -> Data? {
    guard let body = body, PropertyListSerialization.propertyList(body, isValidFor: .xml) else { return nil }
    return try? PropertyListSerialization.data(fromPropertyList: body, format: format, options: options)
  }
}

public struct FormURLEncoder: BodyEncoder {
  public typealias FormURLData = (key: String, value: Any)
  
  public var contentType: String { return "application/x-www-form-urlencoded" }
  
  public init() {}
  
  public func encode(_ body: Any?) -> Data? {
    let aBody: [FormURLData]
    
    switch body {
    case let body as [String : Any]:
      aBody = body.map { (key: $0.key, value: $0.value) }
    case let body as [FormURLData]:
      aBody = body
    default:
      return nil
    }
    
    return aBody.map {
      let key = $0.key.urlQueryPercentEncoded
      let value = "\($0.value)".urlQueryPercentEncoded
      return "\(key)=\(value)"
    }.joined(separator: "&").data(using: .utf8)
  }
}

public struct MultipartEncoder: BodyEncoder {
  public typealias MultipartBinary = (key: String, filename: String, data: Data)
  public typealias MultipartText = (key: String, value: String)
  
  private var boundary = "Boundary-\(UUID().uuidString)"
  public var contentType: String { return "multipart/form-data; boundary=\(boundary)" }
  
  public init() {}
  
  public func encode(_ body: Any?) -> Data? {
    guard let body = body as? [Any] else { return nil }
    return body.compactMap { obj, index in
      var data = Data()
      
      data.append("--\(boundary)\r\n")
      
      switch obj {
      case let aObj as MultipartBinary:
        data.append("Content-Disposition: form-data; name=\"\(aObj.key)\"; filename=\"\(aObj.filename)\"\r\n\r\n")
        data.append(aObj.data)
      case let aObj as MultipartText:
        data.append("Content-Disposition: form-data; name=\"\(aObj.key)\"\r\n\r\n")
        data.append(aObj.value)
      default:
        return nil
      }
      
      data.append("\r\n")
      if index == body.count - 1 {
        data.append("--\(boundary)--")
      }
      
      return data
    }.joined()
  }
}
