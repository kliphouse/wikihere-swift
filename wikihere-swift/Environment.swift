//
//  Environment.swift
//  wikihere-swift
//
//  Created by Jeremy on 7/6/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import Foundation

/// Convenience singleton that wraps environment variables.
struct Environment  {
    
    static let sharedInstance = Environment()
    
    let environmentName: String
    let appName: String
    let wikiBaseUrl: String
    
    private init() {
        let path = Bundle.main.path(forResource: "environment", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        environmentName = dict?["environment"] as! String
        appName = dict?["appName"] as! String
        wikiBaseUrl = dict?["wikiBaseUrl"] as! String
    }
}
