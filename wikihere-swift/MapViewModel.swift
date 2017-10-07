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
    
    let disposeBag = DisposeBag()
    
    private let wikiEntryService: WikiEntryService
    private let geopoint: CLLocation
    
    required init(wikiEntryService: WikiEntryService, geopoint: CLLocation) {
        self.wikiEntryService = wikiEntryService
        self.geopoint = geopoint
    }
    
    private lazy var wikiEntries: Observable<WikiEntries> = self.wikiEntryService.fetchWikiEntries(geopoint: self.geopoint)
    
    public func getWikiEntries() {
        self.wikiEntryService.fetchWikiEntries(geopoint: self.geopoint)
            .subscribe(onNext: { (element) in
                print(element)
            }).addDisposableTo(disposeBag)
                
        }

}
