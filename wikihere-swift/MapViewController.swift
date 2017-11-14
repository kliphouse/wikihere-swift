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

struct MapViewConstants {
    static let maxMoveDistanceForUpdate = 5000.0
    static let maxSpanInDegreesForUpdate = 0.5
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let disposeBag = DisposeBag()
    
    let viewModel = WikiViewModel.sharedInstance
    
    var lastUserLocationUpdate = CLLocation(latitude: 0, longitude: 0)
    var lastWikiEntryLocationUpdate = CLLocation(latitude: 0, longitude: 0)
    
    var firstUpdate = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        mapView.delegate = self
        
        bindAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bindAnnotations() {
        
        viewModel.wikiEntries.subscribe(onNext: { (wikiEntries) in
            //clear old annotations
            let oldAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(oldAnnotations)
            
            //add new annotations
            let annotations = wikiEntries.items.map {
                return WikiAnnotation(item: $0)
            }
            self.mapView.addAnnotations(annotations)
        }).addDisposableTo(disposeBag)
    }
    
    private func setRegion(location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000) //TODO: size the region to wiki radius?
        self.mapView.setRegion(region, animated: true)
    }
    
    private func shouldUpdateMapAtLocation(location: CLLocation) -> Bool {
        
        // Check User Zoom Level by reading one of the region spans.
        if mapView.region.span.latitudeDelta > MapViewConstants.maxSpanInDegreesForUpdate {
            return false
        }
        
        // Check distance to see if we are more than MAX_DIST... from last polled location.
        return location.distance(from: lastWikiEntryLocationUpdate) > MapViewConstants.maxMoveDistanceForUpdate
    }
    
    
    @IBAction func returnToUserLocation(_ sender: Any) {
        
        let userLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        setRegion(location: userLocation)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let currentPoint = userLocation.coordinate
        let location = CLLocation(latitude: currentPoint.latitude, longitude: currentPoint.longitude)
        
        dLog(message: "distance from last user location update: \(location.distance(from: self.lastUserLocationUpdate))")
        //see if we've moved 500 meters, update region and grab WikiEntries
        if location.distance(from: self.lastUserLocationUpdate) >= 5000 {
            self.lastUserLocationUpdate = location
            self.setRegion(location: location)
        }
        
        if firstUpdate {
            viewModel.tuneLocationManager()
            firstUpdate = false
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Get center point of currently displayed region
        let centerPoint = mapView.centerCoordinate
        let centerLocation = CLLocation(latitude: centerPoint.latitude, longitude: centerPoint.longitude)
        
        if shouldUpdateMapAtLocation(location: centerLocation) {
            self.lastWikiEntryLocationUpdate = centerLocation
            viewModel.locationForWikiEntries.onNext(centerLocation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.canShowCallout = true
            annotationView.image = #imageLiteral(resourceName: "location-pin")
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            return annotationView
        }
    }
    
    //animate custom pin view drop
    //https://stackoverflow.com/a/40499511
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        print(#function)
        
        var i = -1;
        for view in views {
            i += 1;
            if view.annotation is MKUserLocation {
                continue;
            }
            
            // Check if current annotation is inside visible map rect, else go to next one
            let point:MKMapPoint  =  MKMapPointForCoordinate(view.annotation!.coordinate);
            if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
                continue;
            }
            
            let endFrame:CGRect = view.frame;
            
            // Move annotation out of view
            view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x,y :view.frame.origin.y-self.view.frame.size.height), size: CGSize(width: view.frame.size.width, height: view.frame.size.height))
            
            // Animate drop
            let delay = 0.03 * Double(i)
            UIView.animate(withDuration: 0.5, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations:{() in
                view.frame = endFrame
                // Animate squash
            }, completion:{(Bool) in
                UIView.animate(withDuration: 0.05, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations:{() in
                    view.transform = CGAffineTransform(scaleX: 1.0, y: 0.6)
                    
                }, completion: {(Bool) in
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations:{() in
                        view.transform = CGAffineTransform.identity
                    }, completion: nil)
                })
                
            })
        }
    }
}

