//
//  Provider.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/8/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

public protocol Provider {
    associatedtype ApiProviderType: ProviderConfiguration
    var provider: ApiProvider<ApiProviderType> { get }
}

public extension Provider {
    var provider: ApiProvider<ApiProviderType> {
        return ApiProvider<ApiProviderType>()
    }
}
