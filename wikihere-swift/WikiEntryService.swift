//
//  WikiEntryService.swift
//  wikihere-swift
//
//  Created by Jeremy on 10/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import RxSwift
import CoreLocation


protocol WikiEntryService {
    
    func getWikiEntries(geopoint: CLLocation, completion: @escaping (_ result: ServiceResult<WikiEntries>) -> Swift.Void)
}

extension WikiEntryService {
    
    //wikientry observable
    func fetchWikiEntries(geopoint: CLLocation) -> Observable<WikiEntries> {
        return Observable.create { observer in
            self.getWikiEntries(geopoint: geopoint, completion: { (result: ServiceResult<WikiEntries>) in
                
                switch(result) {
                case .Success(let wikiEntries):
                    observer.onNext(wikiEntries)
                    observer.onCompleted()
                    break
                case .Failure(let error):
                    observer.onError(error)
                }
                
            })
            return Disposables.create()
        }
    }
}
