//
//  WikiEntryAPI.swift
//  wikihere-swift
//
//  Created by Jeremy on 10/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import Mapper
import CoreLocation
import RxSwift
import RxCocoa
import Alamofire

struct WikiEntryAPI: WikiEntryService {
    
    func getWikiEntries(geopoint: CLLocation, completion: @escaping (ServiceResult<WikiEntries>) -> Void) {
        
        let request = Alamofire.request(
            URL(string: Environment.sharedInstance.wikiBaseUrl)!,
            method: .get,
            parameters: geosearchParams(lat: geopoint.coordinate.latitude, lon: geopoint.coordinate.longitude))
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching WikiEntries: \(String(describing: response.result.error))")
                    let serviceError = ServiceError(serviceCode: ServiceErrorCode.LocalError.rawValue, cause: response.result.error)
                    completion(ServiceResult.Failure(serviceError))
                    return
                }
                
                guard let value = response.result.value as? NSDictionary,
                    let wikiEntries = WikiEntries.from(value) else {
                        print("Malformed data received from wikientry service")
                        let error = MapperError.convertibleError(value: response, type: String.self)  //TODO: not too sure about this one
                        let serviceError = ServiceError(serviceCode: ServiceErrorCode.LocalError.rawValue, cause: error)
                        completion(ServiceResult.Failure(serviceError))
                        return
                }
                
                dLog(message: "*** WikiEntries: \n\(wikiEntries)")
                completion(ServiceResult.Success(wikiEntries))
        }
        
        debugPrint(request)
    }
    
    private func geosearchParams(lat: Double, lon: Double) -> Dictionary<String, String> {
        return [
            "list" : "geosearch", // Asking Wikipedia to do a geosearch
            "format" : "json", // Make sure the format is JSON
            "gslimit" : "50",  // Limit articles to return, hard set to 50
            "gsmaxdim" : "3000", // Limit articles to Wikipedia geo dimension size, hard set to 3000
            "gsradius" : "5000",  // Max search radius
            "gscoord" : "\(lat)|\(lon)" // Lat/Long to conduct search around
        ]
    }
}

