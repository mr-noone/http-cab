//
//  RequestResult.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/6/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public struct RequestResult {
    public let statusCode: Int
    public let data: Data?
    
    public func decodeJSONObject<T: Decodable>(_ object: T.Type) throws -> T {
        guard let data = self.data else {
            throw HTTPCabError.responseError(error: .noData)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw HTTPCabError.responseError(error: .jsonSerializationError(error: error))
        }
    }
    
    public func toJSON() throws -> Any {
        guard let data = self.data else {
            throw HTTPCabError.responseError(error: .noData)
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            throw HTTPCabError.responseError(error: .jsonSerializationError(error: error))
        }
    }
}
