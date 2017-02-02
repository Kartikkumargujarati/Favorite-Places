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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if currentRow == -1{
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }else{
            var lat = NSString(string: allLocations[currentRow]["lat"]!).doubleValue
            var long = NSString(string: allLocations[currentRow]["long"]!).doubleValue
            var latSpan:CLLocationDegrees = 0.008
            var longSpan:CLLocationDegrees = 0.008
            var span:MKCoordinateSpan = MKCoordinateSpanMake(latSpan, longSpan)
            var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
            var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            self.map.setRegion(region, animated: true)
            var annot = MKPointAnnotation()
            annot.coordinate = location
            annot.title = allLocations[currentRow]["name"]
            self.map.addAnnotation(annot)
        }
        
        //locationManager.stopUpdatingLocation()
        var uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        uilpgr.minimumPressDuration = 2.0
        map.addGestureRecognizer(uilpgr)
    }
    func action(_ gestureRec: UILongPressGestureRecognizer) {
        
        if gestureRec.state == UIGestureRecognizerState.began{
            
            var point = gestureRec.location(in: self.map)
            var newCord = self.map.convert(point, toCoordinateFrom: self.map)
            var geoCoder = CLGeocoder()
            var loc = CLLocation(latitude: newCord.latitude, longitude: newCord.longitude)
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
                
                var annot = MKPointAnnotation()
                annot.coordinate = newCord
                if title == ""{
                    title = "New Location"
                }
                annot.title = title
                self.map.addAnnotation(annot)
            })
            
        }
        //locationManager.startUpdatingLocation()
        //locationManager.stopUpdatingLocation()
        

    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var uLocation:CLLocation = locations[0]
        var lat = uLocation.coordinate.latitude
        var long = uLocation.coordinate.longitude
        var latSpan:CLLocationDegrees = 0.008
        var longSpan:CLLocationDegrees = 0.008
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latSpan, longSpan)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.map.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }

}

