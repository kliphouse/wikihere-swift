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
    
    private var locationManager = CLLocationManager()
    
    let disposeBag = DisposeBag()
    
    var currentLocation: Observable<CLLocation?>
    var locationForWikiEntries = PublishSubject<CLLocation>()
    
    let wikiEntries: Observable<WikiEntries>
    
    private let wikiEntryService: WikiEntryService
    
    required init(wikiEntryService: WikiEntryService) {
        
        self.wikiEntryService = wikiEntryService
        
        currentLocation = locationManager.rx.didUpdateLocations.map { locations in
            return locations.first(where: { location -> Bool in
                return location.horizontalAccuracy < 20
            })
        }
        
        wikiEntries = locationForWikiEntries.asObservable()
            .flatMap { location -> Observable<WikiEntries> in
                return wikiEntryService.fetchWikiEntries(geopoint: location)
            }
        
        
//        wikiEntries = currentLocation.flatMapLatest { location -> Observable<WikiEntries> in
//            guard let location = location else {
//                return Observable<WikiEntries>.empty()
//            }
//            return wikiEntryService.fetchWikiEntries(geopoint: location)
//        }
        
        setUpLocationManager()
        
    }
    
    func setUpLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func tuneLocationManager() {
        // Set location manager properties for best battery performance.
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}

