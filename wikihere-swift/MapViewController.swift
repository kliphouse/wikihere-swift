//
//  ViewController.swift
//  wikihere-swift
//
//  Created by Jeremy on 11/15/16.
//  Copyright © 2016 Maurerhouse. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    private var wikiEntries: WikiEntries?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        mapView.delegate = self
        setUpLocationManager()
        
        let viewModel = MapViewModel(wikiEntryService: WikiEntryAPI(), geopoint: CLLocation(latitude: 39.7233, longitude: -77.3939))
        viewModel.getWikiEntries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    func fetchNearbyEntries() {
        guard let location = currentLocation else {
            return
        }
        
        
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }

        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {

                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //
    }
}

