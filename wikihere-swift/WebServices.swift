//
//  WebServices.swift
//  wikihere-swift
//
//  Created by Jeremy on 7/7/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import Foundation
import CoreLocation



enum WebServicesError: Error {
    case urlTrouble
    case jsonMappingTrouble
}



struct WebServices {
    
    static let sharedInstance = WebServices()
    
    
    let config: URLSessionConfiguration
    let session: URLSession
    
    private init() {
        config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
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
    
    func getWikiEntriesWith(geoPoint: CLLocation, completion: @escaping (WikiEntries) -> Void, failure: @escaping (Error) -> Void )  {
        
        let escapedUrlString = escapedUrlStringWith(lat: geoPoint.coordinate.latitude, lon: geoPoint.coordinate.longitude)
        
        guard let url = URL(string: escapedUrlString) else {
            failure(WebServicesError.urlTrouble)
            return
        }
    
//    let lat = 37.7858
//    let long = -122.406
    
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
                        failure(WebServicesError.jsonMappingTrouble)
                        return
                    }
                    
                    dLog(message: "ok then")
                    
                    completion(wikiEntries)
                    
                    
                } catch {
                    
                    print("JSON Processing Failed")
                }
            }
        }
        
    })
    task.resume()
        
    }
    
    
}
