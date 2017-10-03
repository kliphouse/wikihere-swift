//
//  WebServices.swift
//  wikihere-swift
//
//  Created by Jeremy on 7/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import Foundation
import CoreLocation

struct WebServices {
    
    static let sharedInstance = WebServices()
    
    let config: URLSessionConfiguration
    let session: URLSession
    
    private init() {
        config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    /// Get the WikiEntries with a location.
    ///
    /// - Parameters:
    ///   - geoPoint: the user location
    ///   - completion: the block to execute on completion.
    func getWikiEntriesWith(geoPoint: CLLocation, completion: @escaping (ServiceResult<WikiEntries>) -> Void )  {
        
        let escapedUrlString = escapedUrlStringWith(lat: geoPoint.coordinate.latitude, lon: geoPoint.coordinate.longitude)
        
        guard let url = URL(string: escapedUrlString) else {
            completion(ServiceResult.Failure(ServiceError(serviceCode: ServiceErrorCode.UrlError.rawValue)))
            return
        }
    
    let task = session.dataTask(with: url, completionHandler: {
        (data, response, error) in
        
        if error != nil {
            
            print(error!.localizedDescription)
            
        } else {
            
            if let urlContent = data {
                
                do {
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options:
                        JSONSerialization.ReadingOptions.mutableContainers)
                    
                    guard let wikiEntries = WikiEntries.from(jsonResult as! NSDictionary) else {
                        completion(ServiceResult.Failure(ServiceError(serviceCode: ServiceErrorCode.UrlError.rawValue)))
                        return
                    }
                    
                    dLog(message: "Got the WikiEntries")
                    
                    completion(ServiceResult.Success(wikiEntries))
                    
                    
                } catch {
                    
                    print("JSON Processing Failed")
                }
            }
        }
        
    })
    task.resume()
        
    }
    
    private func escapedUrlStringWith(lat: Double, lon: Double) -> String {
        let urlString = Environment.sharedInstance.wikiBaseUrl +
            "&list=geosearch" + // Asking Wikipedia to do a geosearch
            "&format=json" + // Make sure the format is JSON
            "&gslimit=50" + // Limit articles to return, hard set to 50
            "&gsmaxdim=3000" + // Limit articles to Wikipedia geo dimension size, hard set to 3000
            "&gsradius=5000" + // Max search radius
        "&gscoord=\(lat)|\(lon)" // Lat/Long to conduct search around
        
        if let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return escapedString
        } else {
            dLog(message: "URL string encoding failed")
            return ""
        }
    }
    
    
}
