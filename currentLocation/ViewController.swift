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
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var timerField: UITextField!
    
    @IBOutlet weak var scoreField: UITextField!
    //    var annotations: [MKAnnotation] = Array()
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        sender.isHidden = true
        runTimer()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    var currentLocation: CLLocation?
    var seconds = 65
    var timer = Timer()
    var score: Int = 0
    var coordinates: [CLLocationCoordinate2D] = []
    var backgroundMusicPlayer = AVAudioPlayer()
    
    func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        if Int(seconds) < 1 {
            print("Alarm going off")
            timer.invalidate()
            //            performSegue(withIdentifier: "mySegue", sender: nil)
        }
        else {
            self.seconds -= 1
            print(seconds)
            self.timerField.text = String(self.seconds)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // for custom pin annotations
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        playBackgroundMusic(filename: "Viva La Vida.m4a")
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation?.title)! == "You found a berry!"{
            self.score += 5
        }
        else if (view.annotation?.title)! == "You found a poison berry! :("{
            self.score -= 6
        }
        self.scoreField.text = String(self.score)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        //added this code
        manager.stopUpdatingLocation()
        //how much with want to zoom
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        
        //location of the user
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLocation!.coordinate.latitude, currentLocation!.coordinate.longitude)
        
        let region : MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        //making a request for parks  and groceries landmarks
        let request = MKLocalSearchRequest()
        let locations = ["parks", "groceries"]
        var count = 0
        while count < 2 {
            request.naturalLanguageQuery = locations[count]
            request.region = region
            
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else {
                    print("Search error: \(String(describing: error))")
                    return
                }
                
                for item in response.mapItems {
                    let random = arc4random_uniform(3)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate.latitude = item.placemark.coordinate.latitude
                    annotation.coordinate.longitude = item.placemark.coordinate.longitude
                    
                    if random <= 1 {
                        annotation.title = "You found a berry!"
                    }
                        
                    else if random == 2 {
                        annotation.title = "You found a poison berry! :("
                    }
                    self.mapView.addAnnotation(annotation)
                }
                search.cancel()
            }
            count += 1
        }
    }
    
    // Custom pin annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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

