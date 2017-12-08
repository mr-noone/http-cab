//
//  Provider.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/8/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public protocol Provider {
    associatedtype RequestsType: ProviderConfiguration
    var configurator: RequestConfigurator<RequestsType> { get }
}

public extension Provider {
    var configurator: RequestConfigurator<RequestsType> {
        return RequestConfigurator<RequestsType>()
    }
}
