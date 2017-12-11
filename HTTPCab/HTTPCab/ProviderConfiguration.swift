//
//  ProviderConfiguration.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

public protocol ProviderConfiguration {
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var taskType: TaskType { get }
    var headers: HTTPHeaders? { get }
}

public enum TaskType {
    case plainRequest
    case requestWithData(Data)
    case requestWithParameters(params: Parameters, encoding: ParametersEncoding)
    case requestWithEncodableType(Encodable)
    case requestCombinedParams(urlParams: Parameters, bodyParams: Data?)
    case requestCombined(urlParams: Parameters, bodyParams: EncodableCollection, bodyParamsEncoding: ParametersEncoding)
}

public protocol EncodableCollection {
    func encodeWithEncoding(_ encoding: ParametersEncoding) throws -> Data
}

extension Dictionary: EncodableCollection {
    public func encodeWithEncoding(_ encoding: ParametersEncoding) throws -> Data {
        switch encoding {
        case _ as URLEncoding:
            var urlComponents = URLComponents()
            urlComponents.queryItems = self.map { URLQueryItem(paramKey: "\($0)", paramValue: $1 )}
            guard let data = urlComponents.query?.data(using: String.Encoding.utf8) else {
                throw HTTPCabError.parametersEncodingError(error: .urlEncodingError)
            }
            return data
        case _ as JSONEncoding:
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                return data
            } catch {
                throw HTTPCabError.parametersEncodingError(error: .jsonSerializationError(error: error))
            }
        case let plistEncoding as PlistEncoding:
            do {
                let data = try PropertyListSerialization.data(fromPropertyList: self, format: plistEncoding.pListFormat, options: plistEncoding.writeOptions)
                return data
            } catch {
                throw HTTPCabError.parametersEncodingError(error: .pListEncodingError(error: error))
            }
        default: break
        }
        return Data()
    }
}

extension Array: EncodableCollection {
    public func encodeWithEncoding(_ encoding: ParametersEncoding) throws -> Data {
        switch encoding {
        case _ as URLEncoding:
            fatalError("Array can not be urlencoded")
        case _ as JSONEncoding:
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                return data
            } catch {
                throw HTTPCabError.parametersEncodingError(error: .jsonSerializationError(error: error))
            }
        case let plistEncoding as PlistEncoding:
            do {
                let data = try PropertyListSerialization.data(fromPropertyList: self, format: plistEncoding.pListFormat, options: plistEncoding.writeOptions)
                return data
            } catch {
                throw HTTPCabError.parametersEncodingError(error: .pListEncodingError(error: error))
            }
        default: break
        }
        return Data()
    }
}
