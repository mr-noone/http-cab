//
//  BodyEncoder.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public protocol BodyEncoder {
  func encode(_ body: Any?) -> Data?
}

final public class BodyJSONEncoder: BodyEncoder {
  public var options: JSONSerialization.WritingOptions
  
  public init(options: JSONSerialization.WritingOptions = .prettyPrinted) {
    self.options = options
  }
  
  public func encode(_ body: Any?) -> Data? {
    guard let body = body, JSONSerialization.isValidJSONObject(body) else { return nil }
    return try? JSONSerialization.data(withJSONObject: body, options: options)
  }
}

final public class BodyPlistEncoder: BodyEncoder {
  public let pListFormat: PropertyListSerialization.PropertyListFormat
  public let writeOptions: PropertyListSerialization.WriteOptions
  
  public init(pListFormat: PropertyListSerialization.PropertyListFormat = .xml, writeOptions: PropertyListSerialization.WriteOptions = 0) {
    self.pListFormat = pListFormat
    self.writeOptions = writeOptions
  }
  
  public func encode(_ body: Any?) -> Data? {
    guard let body = body, PropertyListSerialization.propertyList(body, isValidFor: .xml) else { return nil }
    return try? PropertyListSerialization.data(fromPropertyList: body, format: pListFormat, options: writeOptions)
  }
}
