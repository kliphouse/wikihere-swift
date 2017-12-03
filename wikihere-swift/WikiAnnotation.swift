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
    let wikiItem: WikiEntryItem
    let coordinate: CLLocationCoordinate2D
    
    init(item: WikiEntryItem, currentLocation: CLLocation)  {
        coordinate = item.coordinate
        pageId = "\(item.pageId)"
        title = "\(item.title)"
        wikiItem = item
        
        let itemLocation = CLLocation(coordinate2D: item.coordinate)
        let distanceInMeters = currentLocation.distance(from: itemLocation)
        subtitle = "\(round((distanceInMeters * 0.000621371) * 100) / 100) miles"
    }

    func imageUrl() -> String? {
        guard let url = wikiItem.imageUrl else {
            return nil
        }
        return url
    }
}
