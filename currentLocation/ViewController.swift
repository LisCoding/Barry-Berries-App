//
//  ViewController.swift
//  currentLocation
//
//  Created by Liseth Cardozo Sejas on 9/14/17.
//  Copyright © 2017 Liseth Cardozo Sejas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var annotations: [MKAnnotation] = Array()
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    //add pointers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let user_location = locations[0]
        //how much with want to zoom
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        
        //location of the user
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(user_location.coordinate.latitude, user_location.coordinate.longitude)
        
        let region : MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "grocery"
        request.region = self.mapView.region
        
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(String(describing: error))")
                return
            }
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = item.placemark.coordinate.latitude
                annotation.coordinate.longitude = item.placemark.coordinate.longitude
                self.mapView.addAnnotation(annotation)
            }
            search.cancel()
        }
        
        let request2 = MKLocalSearchRequest()
        request2.naturalLanguageQuery = "grocery"
        request2.region = self.mapView.region
        
        
        let search2 = MKLocalSearch(request: request)
        search2.start { (response, error) in
            guard let response = response else {
                print("Search error: \(String(describing: error))")
                return
            }
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = item.placemark.coordinate.latitude
                annotation.coordinate.longitude = item.placemark.coordinate.longitude
                self.mapView.addAnnotation(annotation)
            }
            search2.cancel()
        }
    }
}

