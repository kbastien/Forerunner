//
//  ViewController.swift
//  Forerunner
//
//  Created by Kevin Bastien on 6/16/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class SelectDistanceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var distancePicker: UIPickerView!
    let pickerViewData = Array(1...50)
    let pickerViewRows = 10000
    let locationManager = CLLocationManager()
    
    var lat:CLLocationDegrees!
    var long:CLLocationDegrees!
    
    let CLIENT_ID = "3FR3WRO5GNGGHG5DYSKTDGB1SDCV0PGLJT4WCI3GJDWI1DMS"
    let CLIENT_SECRET = "SZJPN1B5JARBOCWDVBN2T345UQSJ3TAGZWMGDZRQERBSAX5B"
    
    struct PickerSelected {
        static var selectedNumber:Int?
    }
    
    struct LocationInformation {
        static var lat: CLLocationDegrees = 0.0
        static var long: CLLocationDegrees = 0.0
        static var cityState: String?
    }
    
    struct DataTransfer {
        static var foursquareData = [FoursquareDataType]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distancePicker.dataSource = self
        distancePicker.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func valueForRow(row: Int) -> Int {
        // the rows repeat every `pickerViewData.count` items
        return pickerViewData[row % pickerViewData.count]
    }
    
    func rowForValue(value: Int) -> Int? {
        let pickerViewMiddle = ((pickerViewRows / pickerViewData.count) / 2) * pickerViewData.count
        NSLog("VALUE: \(value)")
        if let valueIndex = find(pickerViewData, value) {
            return pickerViewMiddle + value
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(valueForRow(row))"
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewRows
    }
    
    // whenever the picker view comes to rest, we'll jump back to
    // the row with the current value that is closest to the middle
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        PickerSelected.selectedNumber = nil
        //let pickerViewMiddle = ((pickerViewRows / pickerViewData.count) / 2) * pickerViewData.count
        //rounds up row
        let newRow = (row % pickerViewData.count)
        PickerSelected.selectedNumber = pickerViewData[pickerView.selectedRowInComponent(0)]
        pickerView.selectRow(newRow, inComponent: 0, animated: false)
        print("Resetting row to \(newRow)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("Error: " + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
                if let city = pm.addressDictionary["City"] as? NSString {
                    LocationInformation.cityState = city as String
                    if let state = pm.addressDictionary["State"] as? NSString {
                        LocationInformation.cityState = (city as String) + ", " + (state as String)
                    }
                }
            }
            
            let placeArray = placemarks as! [CLPlacemark]
            let coordinate = manager.location.coordinate
            LocationInformation.lat = coordinate.latitude
            LocationInformation.long = coordinate.longitude
            self.foursquareCall()
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        self.locationManager.stopUpdatingLocation()
        NSLog("Locality: \(placemark.locality)")
        NSLog("Postal Code: %d \(placemark.postalCode)")
        NSLog("Admin Area: \(placemark.administrativeArea)")
        NSLog("Country: \(placemark.country)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
    private func foursquareCall(){
        var postEndpoint: String = "https://api.foursquare.com/v2/venues/explore?client_id=" + CLIENT_ID + "&client_secret=" + CLIENT_SECRET + "&v=20130815&ll=\(LocationInformation.lat),\(LocationInformation.long)&limit=20"
        
        Alamofire.request(.GET, postEndpoint)
            .responseJSON { (request, response, data, error) in
                if let anError = error
                {
                    // got an error in getting the data, need to handle it
                    print("error calling GET")
                    print(error)
                }
                else if let data: AnyObject = data // responseJSON gives us AnyObject? while JSON() expects AnyObject
                    // JSON(data!) will crash if we get back empty data, so we keep the one ugly unwrapping line
                    // to test, try changing postEndpoint to "http://jsonplaceholder.typicode.com/posts/111111111111"
                {
                    // handle the results as JSON, without a bunch of nested if loops
                    let post = JSON(data)
                    println(post["response"]["groups"][0]["items"][0]["venue"]["categories"][0]["pluralName"])
                    for var i = 1; i <= post["response"]["groups"][0]["items"].count; i++ {
                        DataTransfer.foursquareData.append(FoursquareDataType(name: post["response"]["groups"][0]["items"][i-1]["venue"]["name"].string!, category: post["response"]["groups"][0]["items"][i-1]["venue"]["categories"][0]["pluralName"].string!, lat: post["response"]["groups"][0]["items"][i-1]["venue"]["location"]["lat"].int!, long:post["response"]["groups"][0]["items"][i-1]["venue"]["location"]["lng"].int!))
                        println("\(i)")
                        println("CATEGORY is: " + post["response"]["groups"][0]["items"][i-1]["venue"]["categories"][0]["pluralName"].string!)
                        println("Category is: \(DataTransfer.foursquareData[i-1].category)")
                    }
                    // now we have the results, let's just print them though a tableview would definitely be better UI:
                    print("The post is: " + post.description)
                    if let title = post["title"].string
                    {
                        // to access a field:
                        print("The title is: " + title)
                    }
                    else
                    {
                        print("error parsing")
                    }
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "getToSelectTagsSegue") {
            let passedValue = segue.destinationViewController as! SelectTagViewController;
            foursquareCall()
            passedValue.cityState = LocationInformation.cityState
            passedValue.foursquareData = DataTransfer.foursquareData
            if PickerSelected.selectedNumber == nil {
                passedValue.toPass = 1
            }
            else {
                passedValue.toPass = PickerSelected.selectedNumber
            }
        }
    }

}

