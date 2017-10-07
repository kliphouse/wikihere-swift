//
//  MapViewModel.swift
//  wikihere-swift
//
//  Created by Jeremy on 10/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import RxCocoa
import RxSwift
import CoreLocation

class MapViewModel {
    
    private var locationManager: CLLocationManager!
    
    var currentLocation: Observable<CLLocation?>
    let wikiEntries: Observable<WikiEntries>
    
    private let wikiEntryService: WikiEntryService
    
    required init(wikiEntryService: WikiEntryService) {
        
        self.wikiEntryService = wikiEntryService
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        currentLocation = locationManager.rx.didUpdateLocations.map { locations in
            return locations.first(where: { location -> Bool in
                return location.horizontalAccuracy < 20
            })
        }
        
        wikiEntries = currentLocation.flatMapLatest { location -> Observable<WikiEntries> in
            guard let location = location else {
                return Observable<WikiEntries>.empty()
            }
            return wikiEntryService.fetchWikiEntries(geopoint: location)
        }
    }
    
    func setUpLocationManager() {
        
    }
}

