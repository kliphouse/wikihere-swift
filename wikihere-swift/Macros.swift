//
//  Macros.swift
//  wikihere-swift
//
//  Created by Jeremy on 7/6/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import Foundation

func dLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        NSLog("[\((filename as NSString).lastPathComponent):\(line)] \(function) - \(message)")
    #endif
}
