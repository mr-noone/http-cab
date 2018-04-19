//
//  HTTPError.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 03.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public class HTTPError: NSError {
  static public let HTTPErrorDescription = "Description"
  
  public enum Domain {
    static public let HTTPClientErrorDomain = "HTTPClientErrorDomain"
    static public let HTTPServerErrorDomain = "HTTPServerErrorDomain"
  }
  
  public override var localizedDescription: String {
    return HTTPURLResponse.localizedString(forStatusCode: code)
  }
  
  convenience init?(_ httpResponse: HTTPURLResponse, data: Data? = nil) {
    if 400...599 ~= httpResponse.statusCode {
      let userInfo = HTTPError.userInfo(from: data)
      self.init(code: httpResponse.statusCode, userInfo: userInfo)
    } else {
      return nil
    }
  }
  
  convenience init?(code: Int, userInfo: [String: Any]? = nil) {
    switch code {
    case 400...499:
      self.init(domain: Domain.HTTPClientErrorDomain, code: code, userInfo: userInfo)
    case 500...599:
      self.init(domain: Domain.HTTPServerErrorDomain, code: code, userInfo: userInfo)
    default:
      return nil
    }
  }
  
  static func userInfo(from data: Data?) -> [String: Any]? {
    guard let data = data else { return nil }
    
    do {
      return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    } catch {
      if let message = String(data: data, encoding: .utf8) {
        return [HTTPErrorDescription: message];
      } else {
        return nil
      }
    }
  }
}
