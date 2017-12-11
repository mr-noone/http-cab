//
//  EncodingCollections.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/10/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public typealias PropertyListFormat = PropertyListSerialization.PropertyListFormat
public typealias PropertyListWriteOptions = PropertyListSerialization.WriteOptions

public extension Dictionary where Key == String {
    public func urlEncoded() -> Data? {
        var urlComponents = URLComponents()
        urlComponents.queryItems = self.map { URLQueryItem(paramKey: "\($0)", paramValue: $1 )}
        return urlComponents.query?.data(using: String.Encoding.utf8)
    }
    
    public func jsonEncoded() -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            print("ENCODING ERROR : Dictionary json encoding failed")
            return nil
        }
        return data
    }
    
    public func plistEncodedWithPlistFormat(_ format: PropertyListFormat) -> Data? {
        guard let data = try? PropertyListSerialization.data(fromPropertyList: self, format: format, options: 0) else {
            print("ENCODING ERROR : Dictionary plist encoding failed")
            return nil
        }
        return data
    }
}

extension Array {
    public func urlEncoded(key: String) -> Data? {
        let arrayKey = key.hasSuffix("[]") ? key : key.appending("[]")
        var urlComponents = URLComponents()
        urlComponents.queryItems = self.map { URLQueryItem(paramKey: arrayKey, paramValue: $0) }
        return urlComponents.query?.data(using: String.Encoding.utf8)
    }
    
    public func jsonEncoded() -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            print("ENCODING ERROR : Array json encoding failed")
            return nil
        }
        return data
    }
    
    public func plistEncodedWithPlistFormat(_ format: PropertyListFormat) -> Data? {
        guard let data = try? PropertyListSerialization.data(fromPropertyList: self, format: format, options: 0) else {
            print("ENCODING ERROR : Array plist encoding failed")
            return nil
        }
        return data
    }
}
