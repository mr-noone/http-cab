//
//  HTTPStatusCode.swift
//  HTTPCab
//
//  Created by Aleksey Zgurskiy on 05.04.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public enum HTTPStatusCode {
  // MARK: - Informational
  
  public static let `continue` = 100
  public static let switchingProtocols = 101
  public static let processing = 102
  
  // MARK: - Success
  
  public static let ok = 200
  public static let created = 201
  public static let accepted = 202
  public static let nonAuthoritativeInformation = 203
  public static let noContent = 204
  public static let resetContent = 205
  public static let partialContent = 206
  public static let multiStatus = 207
  public static let alreadyReported = 208
  public static let imUsed = 226
  
  // MARK: - Redirection
  
  public static let multipleChoices = 300
  public static let movedPermanently = 301
  public static let found = 302
  public static let seeOther = 303
  public static let notModified = 304
  public static let useProxy = 305
  public static let temporaryRedirect = 307
  public static let permanentRedirect = 308
  
  // MARK: - Client Error
  
  public static let badRequest = 400
  public static let unauthorized = 401
  public static let paymentRequired = 402
  public static let forbidden = 403
  public static let notFound = 404
  public static let methodNotAllowed = 405
  public static let notAcceptable = 406
  public static let proxyAuthenticationRequired = 407
  public static let requestTimeout = 408
  public static let conflict = 409
  public static let gone = 410
  public static let lengthRequired = 411
  public static let preconditionFailed = 412
  public static let payloadTooLarge = 413
  public static let uriTooLong = 414
  public static let unsupportedMediaType = 415
  public static let rangeNotSatisfiable = 416
  public static let expectationFailed = 417
  public static let misdirectedRequest = 421
  public static let unprocessableEntity = 422
  public static let locked = 423
  public static let failedDependency = 424
  public static let upgradeRequired = 426
  public static let preconditionRequired = 428
  public static let tooManyRequests = 429
  public static let requestHeaderFieldsTooLarge = 431
  public static let unavailableForLegalReasons = 451
  
  // MARK: - Server Error
  
  public static let internalServerError = 500
  public static let notImplemented = 501
  public static let badGateway = 502
  public static let serviceUnavailable = 503
  public static let gatewayTimeout = 504
  public static let httpVersionNotSupported = 505
  public static let variantAlsoNegotiates = 506
  public static let insufficientStorage = 507
  public static let loopDetected = 508
  public static let notExtended = 510
  public static let networkAuthenticationRequired = 511
}
