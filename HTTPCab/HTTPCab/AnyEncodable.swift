//
//  AnyEncodable.swift
//  HTTPCab
//
//  Created by Igor Voytovich on 12/7/17.
//  Copyright © 2017 Graviti Mobail. All rights reserved.
//

import Foundation

struct AnyEncodable: Encodable {
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
