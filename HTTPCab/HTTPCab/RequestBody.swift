//
//  RequestBody.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 5/21/19.
//  Copyright © 2019 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public protocol JSONRoot {}
public protocol JSONConvertible {}

public protocol PlistRoot {}
public protocol PlistConvertible {}

extension Array: JSONRoot,  JSONConvertible  where Element == JSONConvertible {}
extension Array: PlistRoot, PlistConvertible where Element == PlistConvertible {}

extension Dictionary: JSONRoot,  JSONConvertible  where Key == String, Value == JSONConvertible? {}
extension Dictionary: PlistRoot, PlistConvertible where Key == String, Value == PlistConvertible {}

extension String: JSONConvertible, PlistConvertible {}

extension Int:   JSONConvertible, PlistConvertible {}
extension Int8:  JSONConvertible, PlistConvertible {}
extension Int16: JSONConvertible, PlistConvertible {}
extension Int32: JSONConvertible, PlistConvertible {}
extension Int64: JSONConvertible, PlistConvertible {}

extension UInt:   JSONConvertible, PlistConvertible {}
extension UInt8:  JSONConvertible, PlistConvertible {}
extension UInt16: JSONConvertible, PlistConvertible {}
extension UInt32: JSONConvertible, PlistConvertible {}
extension UInt64: JSONConvertible, PlistConvertible {}

extension Float:  JSONConvertible, PlistConvertible {}
extension Double: JSONConvertible, PlistConvertible {}

extension Bool: JSONConvertible, PlistConvertible {}

extension Date: PlistConvertible {}
extension Data: PlistConvertible {}

public protocol RequestBody {
  var contentType: String { get }
  var bodyData: Data { get }
}

public struct JSONBody: RequestBody {
  public let contentType = "application/json"
  public let bodyData: Data
  
  public init?(_ data: JSONRoot, options: JSONSerialization.WritingOptions = .prettyPrinted) {
    guard
      JSONSerialization.isValidJSONObject(data),
      let data = try? JSONSerialization.data(withJSONObject: data, options: options)
    else { return nil }
    self.bodyData = data
  }
}

public struct PlistBody: RequestBody {
  public let contentType = "application/xml"
  public let bodyData: Data
  
  public init?(_ data: PlistRoot,
               format: PropertyListSerialization.PropertyListFormat = .xml,
               options: PropertyListSerialization.WriteOptions = 0) {
    guard
      PropertyListSerialization.propertyList(data, isValidFor: format),
      let data = try? PropertyListSerialization.data(fromPropertyList: data, format: format, options: options)
    else { return nil }
    bodyData = data
  }
}

public struct FormURLBody: RequestBody {
  public let contentType = "application/x-www-form-urlencoded"
  public let bodyData: Data
  
  public init?(_ data: [String : Any]) {
    let data = data.map {
      let key = $0.key.urlQueryPercentEncoded
      let value = "\($0.value)".urlQueryPercentEncoded
      return "\(key)=\(value)"
    }.joined(separator: "&").data(using: .utf8)
    
    guard let bodyData = data else { return nil }
    self.bodyData = bodyData
  }
}

public struct MultipartBody: RequestBody {
  public typealias MultipartBinary = (key: String, filename: String, data: Data)
  public typealias MultipartText = (key: String, value: Any)
  
  public var contentType: String {
    return "multipart/form-data; boundary=\(boundary)"
  }
  
  public var bodyData: Data {
    return values.compactMap { (aObj, index) in
      var data = Data()
      
      data.append("--\(boundary)\r\n")
      
      switch aObj {
      case let obj as MultipartBinary:
        data.append("Content-Disposition: form-data; name=\"\(obj.key)\"; filename=\"\(obj.filename)\"\r\n\r\n")
        data.append(obj.data)
      case let obj as MultipartText:
        data.append("Content-Disposition: form-data; name=\"\(obj.key)\"\r\n\r\n")
        data.append("\(obj.value)")
      default:
        return nil
      }
      
      data.append("\r\n")
      if index == values.count - 1 {
        data.append("--\(boundary)--")
      }
      
      return data
    }.joined()
  }
  
  private let boundary = "Boundary-\(UUID().uuidString)"
  private var values = [Any]()
  
  public init() {}
  
  @discardableResult
  public mutating func append(binary value: MultipartBinary) -> MultipartBody {
    values.append(value)
    return self
  }
  
  @discardableResult
  public mutating func append(text value: MultipartText) -> MultipartBody {
    values.append(value)
    return self
  }
}

public struct JSONEncodableBody<T: Encodable>: RequestBody {
  public let contentType: String = "application/json"
  public let bodyData: Data
  
  public init?(_ body: T, encoder: JSONEncoder = JSONEncoder()) {
    guard let bodyData = try? encoder.encode(body) else { return nil }
    self.bodyData = bodyData
  }
}
