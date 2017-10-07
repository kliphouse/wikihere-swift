//
//  WikiAnnotation.swift
//  wikihere-swift
//
//  Created by Jeremy on 10/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import MapKit


class WikiAnnotation: NSObject, MKAnnotation {
    
    let pageId: String
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(item: WikiEntryItem)  {
        coordinate = CLLocationCoordinate2DMake(item.lat, item.lon)
        pageId = "\(item.pageId)"
        title = "\(item.title)"
        subtitle = String(format: "%d meters", item.dist)
    }
}
