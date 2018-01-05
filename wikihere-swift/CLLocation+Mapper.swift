//
//  CLLocation+Mapper.swift
//  wikihere-swift
//
//  Created by Jeremy on 11/13/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import CoreLocation
import Mapper


extension CLLocationCoordinate2D: Convertible {
    public static func fromMap(_ value: Any) throws -> CLLocationCoordinate2D {
        guard let coordinates = value as? Array<NSDictionary?>,
            let location = coordinates[0],
            let latitude = location["lat"] as? Double,
            let longitude = location["lon"] as? Double else
        {
            throw MapperError.convertibleError(value: value, type: [String: Double].self)
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension CLLocation {
    convenience init(coordinate2D: CLLocationCoordinate2D) {
        let lat = coordinate2D.latitude
        let lon = coordinate2D.longitude
        self.init(latitude: lat, longitude: lon)
    }
}

