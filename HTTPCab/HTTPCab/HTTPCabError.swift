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
    case jsonSerializationError(error: Error)
}

public enum ResponseError: Error {
    case noData
    case jsonSerializationError(error: Error)
    case invalidHTTPResponse
}

public enum HTTPCabError: Error {
    case invalidUrl(url: URL)
    case parametersEncodingError(error: ParametersEncodingError)
    case responseError(error: ResponseError)
}
