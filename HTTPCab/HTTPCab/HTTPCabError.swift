//
//  HTTPCabError.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public enum ParametersEncodingError {
  case noUrl
  case invalidEncoding
  case invalidTypeToEncode(type: String)
  case urlEncodingError
  case invalidJSON
  case jsonSerializationError(error: Error)
  case pListEncodingError(error: Error)
  case plainTextEncodingError
}

public enum ResponseError: Error {
  case noData
  case jsonSerializationError(error: Error)
  case invalidHTTPResponse
}

public enum MappingError: Error {
  case requestMapping(String)
  case encodableMapping
}

public enum HTTPCabError: Error {
  case invalidUrl(url: URL)
  case mappingError(error: MappingError)
  case parametersEncodingError(error: ParametersEncodingError)
  case responseError(error: ResponseError)
}

public struct HTTPError: Error {
  public let code: Int
  public var localizedDescription: String {
    return HTTPURLResponse.localizedString(forStatusCode: code)
  }
  
  init?(code: Int) {
    switch code {
    case 400...499, 500...599:
      self.code = code
    default:
      return nil
    }
  }
}
