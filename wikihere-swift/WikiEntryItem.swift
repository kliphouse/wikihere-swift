//
//  WikiEntry.swift
//  wikihere-swift
//
//  Created by Jeremy on 7/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import Mapper
import CoreLocation

struct WikiEntryItem: Mappable {
    
    let pageId: Int
    let title: String
    let coordinate: CLLocationCoordinate2D
    let imageUrl: String?
    
    init(map: Mapper) throws {
        try pageId = map.from("pageid")
        try title = map.from("title")
        try coordinate = map.from("coordinates")
        imageUrl = map.optionalFrom("thumbnail.source")
    }
}
