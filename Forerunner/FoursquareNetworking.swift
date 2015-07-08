//
//  FoursquareNetworking.swift
//  Forerunner
//
//  Created by Kevin Bastien on 7/6/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class FoursquareNetworking: UIViewController, CLLocationManagerDelegate {
    
    var location = CLLocationManager()
    let CLIENT_ID = "3FR3WRO5GNGGHG5DYSKTDGB1SDCV0PGLJT4WCI3GJDWI1DMS"
    let CLIENT_SECRET = "SZJPN1B5JARBOCWDVBN2T345UQSJ3TAGZWMGDZRQERBSAX5B"
    
    struct latLong {
        static var lat:CLLocationDegrees?
        static var long:CLLocationDegrees?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocation()
        println("LATLONG ::::: \(latLong.lat) \(latLong.long)")
        // Do any additional setup after loading the view, typically from a nib.
        var postEndpoint: String = "https://api.foursquare.com/v2/venues/search?client_id=" + CLIENT_ID + "&client_secret=" + CLIENT_SECRET + "&v=20130815&ll=\(latLong.lat),\(latLong.long)&query=sushi"
        
        Alamofire.request(.GET, postEndpoint)
            .responseJSON { (request, response, data, error) in
                if let anError = error
                {
                    // got an error in getting the data, need to handle it
                    println("error calling GET")
                    println(error)
                }
                else if let data: AnyObject = data // hate this but responseJSON gives us AnyObject? while JSON() expects AnyObject
                    // JSON(data!) will crash if we get back empty data, so we keep the one ugly unwrapping line
                    // to test, try changing postEndpoint to "http://jsonplaceholder.typicode.com/posts/111111111111"
                {
                    // handle the results as JSON, without a bunch of nested if loops
                    let post = JSON(data)
                    // now we have the results, let's just print them though a tableview would definitely be better UI:
                    println("The post is: " + post.description)
                    if let title = post["title"].string
                    {
                        // to access a field:
                        println("The title is: " + title)
                    }
                    else
                    {
                        println("error parsing")
                    }
                }
            }
        
    }
    
    private func updateCurrentLocation() {
        location.delegate = self
        
        location.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            location.desiredAccuracy = kCLLocationAccuracyBest
            location.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        latLong.lat = locValue.latitude
        latLong.long = locValue.longitude
        println("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}