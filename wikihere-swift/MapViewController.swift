//
//  ViewController.swift
//  wikihere-swift
//
//  Created by Jeremy on 11/15/16.
//  Copyright © 2016 Maurerhouse. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let disposeBag = DisposeBag()
    
    let viewModel = MapViewModel(wikiEntryService: WikiEntryAPI())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        mapView.delegate = self
        
        bindToCurrentLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bindToCurrentLocation() {
        viewModel.currentLocation.subscribe(onNext: { (location) in
            guard let location = location else {
                return
            }
            
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
            self.mapView.setRegion(region, animated: true)
        }).addDisposableTo(disposeBag)
        
        viewModel.wikiEntries.subscribe(onNext: { (wikiEntries) in
            
            let annotations = wikiEntries.items.map {
                return WikiAnnotation(item: $0)
            }
            self.mapView.addAnnotations(annotations)
        }).addDisposableTo(disposeBag)
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

