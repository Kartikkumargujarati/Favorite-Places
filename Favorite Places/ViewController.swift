//
//  ViewController.swift
//  Favorite Places
//
//  Created by Kartik on 2/1/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    @IBAction func locateMe(_ sender: AnyObject) {
        
        //Get Device location on button click
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start the Map with user's current location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if currentRow == -1{
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }else{
            let lat = NSString(string: allLocations[currentRow]["lat"]!).doubleValue
            let long = NSString(string: allLocations[currentRow]["long"]!).doubleValue
            let latSpan:CLLocationDegrees = 0.008
            let longSpan:CLLocationDegrees = 0.008
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latSpan, longSpan)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            self.map.setRegion(region, animated: true)
            
            //Add annotation to map
            let annot = MKPointAnnotation()
            annot.coordinate = location
            annot.title = allLocations[currentRow]["name"]
            self.map.addAnnotation(annot)
        }
        
        //On long press on a location
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        uilpgr.minimumPressDuration = 2.0
        map.addGestureRecognizer(uilpgr)
    }
    
    //Function to perform when long pressed on a location in map
    func action(_ gestureRec: UILongPressGestureRecognizer) {
        
        if gestureRec.state == UIGestureRecognizerState.began{
            
            let point = gestureRec.location(in: self.map)
            let newCord = self.map.convert(point, toCoordinateFrom: self.map)
            let geoCoder = CLGeocoder()
            let loc = CLLocation(latitude: newCord.latitude, longitude: newCord.longitude)
            
            //Get the address from the latitude and Longitude
            geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placeMarks, error) in
                var title = ""
                if(error == nil){
                    guard let address = placeMarks?[0].addressDictionary else {
                        return
                    }
                    let name = address["Name"] as! String
                    let street = address["Street"] as! String
                    let  city = address["City"] as! String
                    let state = address["State"] as! String
                    let zip = address["ZIP"] as! String
                    let country = address["Country"] as! String
                    if name == street{
                        title = "\(street)"
                    }else{
                        title = "\(name) \(street)"
                    }
                }
                allLocations.append(["name": title, "lat": "\(newCord.latitude)", "long": "\(newCord.longitude)"])
                
                //Set the value
                UserDefaults.standard.set(allLocations, forKey: "allLocations")
                let annot = MKPointAnnotation()
                annot.coordinate = newCord
                if title == ""{
                    title = "New Location"
                }
                annot.title = title
                self.map.addAnnotation(annot)
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let uLocation:CLLocation = locations[0]
        let lat = uLocation.coordinate.latitude
        let long = uLocation.coordinate.longitude
        let latSpan:CLLocationDegrees = 0.008
        let longSpan:CLLocationDegrees = 0.008
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latSpan, longSpan)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.map.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

