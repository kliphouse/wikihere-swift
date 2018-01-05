//
//  WikiEntries.swift
//  wikihere-swift
//
//  Created by Jeremy on 7/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import Mapper

struct WikiEntries: Mappable {
    let items: Array<WikiEntryItem>
    
    init(map: Mapper) throws {
        items = map.optionalFrom("query.pages") ?? []
    }
}
