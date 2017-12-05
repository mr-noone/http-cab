//
//  HTTPCabProvider.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public protocol HTTPCabProviderType {
    associatedtype TaskType: RequestableType
}

public class HTTPCabProvider<T: RequestableType>: HTTPCabProviderType {
    func request(_ target: T) {
        
    }
}
