//
//  AppDelegate.swift
//  Example
//
//  Created by Igor Voytovich on 12/5/17.
//  Copyright © 2017 NullGR. All rights reserved.
//

import UIKit
import HTTPCab

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let url = URL(string: "http://localhost:3000/posts")
        HTTPCab.request(url!, method: .post, parameters: ["author": "John", "title": "Smith"], headers: nil, parametersEncoding: JSONEncoding.default) { (status) in
            switch status {
            case .success(value: let result):
                print(result.statusCode)
                print(try! result.mapJSON())
            case .failure(error: let error):
                print(error.localizedDescription)
            }
        }
        
        let data = ["Value1", "Value2", "Value3"].jsonEncoded()
        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        print(json)
        
        let provider = RequestsProvider()
        provider.request()
        
        return true
    }
}

