//
//  WikiEntry.swift
//  wikihere-swift
//
//  Created by Jeremy on 7/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import Mapper

struct WikiEntryItem: Mappable {
    
    let pageId: Int
    let title: String
    let lat: Double
    let lon: Double
    let dist: Double
    let imageUrl: String = ""
    
    init(map: Mapper) throws {
        try pageId = map.from("pageid")
        try title = map.from("title")
        try lat = map.from("lat")
        try lon = map.from("lon")
        try dist = map.from("dist")
    }
}
