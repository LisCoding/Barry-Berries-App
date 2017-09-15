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

    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    //add pointers
    let annotation = MKPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "grocery"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(error)")
                return
            }
            for item in response.mapItems {
                print (item.placemark.coordinate.latitude) // add information to pins
                print(item.name!)
            }
        }

        mapView.addAnnotation(annotation)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let user_location = locations[0]
        //how much with want to zoom
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        
        //location of the user
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(user_location.coordinate.latitude, user_location.coordinate.longitude)

            
            
        annotation.coordinate = CLLocationCoordinate2D(latitude: (user_location.coordinate.latitude + 0.01), longitude: (user_location.coordinate.longitude + 0.01))
//        annotation.coordinate = CLLocationCoordinate2D(latitude: (user_location.coordinate.latitude + 0.03), longitude: (user_location.coordinate.longitude + 0.03))
        
        let region : MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
   
}

