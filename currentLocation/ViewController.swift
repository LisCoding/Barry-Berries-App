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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //    var annotations: [MKAnnotation] = Array()
    
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    // custom pin annotations
    var pointAnnotation: CustomPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    //add pointers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // for custom pin annotations
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let user_location = locations[0]
        //added this code
        manager.stopUpdatingLocation()
        //how much with want to zoom
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        
        //location of the user
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(user_location.coordinate.latitude, user_location.coordinate.longitude)
        
        let region : MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        
        
        //making a request for parks  and groceries landmarks
        let request = MKLocalSearchRequest()
        let locations = ["parks", "groceries"]
        var count = 0
        while count < 2 {
            request.naturalLanguageQuery = locations[count]
            //change
            request.region = region
            
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else {
                    print("Search error: \(String(describing: error))")
                    return
                }
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.title! = "You found a berry!"
                    annotation.subtitle! = "Do you want to eat it? Tap to continue..."
//                    print(annotation.title)
//                    print(annotation.subtitle)
                    annotation.coordinate.latitude = item.placemark.coordinate.latitude
                    annotation.coordinate.longitude = item.placemark.coordinate.longitude
                    //adding annotation to the map
//                    self.mapView.addAnnotation(annotation)
                    print("This  is my annotation", annotation)
                    // custom pin annotations
//                    self.pointAnnotation = CustomPointAnnotation()
//                    self.pointAnnotation.pinCustomImageName = "berry"
//                    self.pointAnnotation.coordinate = myLocation

//                    self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: "pin")
                    self.mapView.addAnnotation(annotation)
                }
                search.cancel()
            }
            count += 1
        }

    }
    
    // Custom pin annotations
    func mapAnnotationView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
//        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView!.image = UIImage(named: "berry")
        
        return annotationView
    }
}

