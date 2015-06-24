//
//  SelectTagViewController.swift
//  Forerunner
//
//  Created by Kevin Bastien on 6/17/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit
import CoreLocation

class SelectTagViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    var locationManager = CLLocationManager()
    var currentDistancePicked = MyVariables.currentDistancePicked
    var toPass:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocation()
        NSLog("This is the current distance!!! \(currentDistancePicked)")
        NSLog("This is the number picked: %d", toPass)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateCurrentLocation() {
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        
        let coordinate = manager.location.coordinate
        var geoCoder = CLGeocoder()
        var location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            let placeArray = placemarks as! [CLPlacemark]
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray[0]
            
            // City, State
            if let city = placeMark.addressDictionary["City"] as? NSString {
                println(city)
                
                if let state = placeMark.addressDictionary["State"] as? NSString {
                    self.currentLocationLabel.text = "\(city), \(state)"
                }
            }
            
        })

    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}