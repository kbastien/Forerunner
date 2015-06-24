//
//  ViewController.swift
//  Forerunner
//
//  Created by Kevin Bastien on 6/16/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit
import CoreLocation

class SelectDistanceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var distancePicker: UIPickerView!
    let pickerViewData = Array(0...50)
    let pickerViewRows = 10000
    let locationManager = CLLocationManager()
    
    struct PickerSelected {
        static var selectedNumber:Int?
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
        println("Resetting row to \(newRow)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("Error: " + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        self.locationManager.stopUpdatingLocation()
        NSLog("Locality: \(placemark.locality)")
        NSLog("Postal Code: %d \(placemark.postalCode)")
        NSLog("Admin Area: \(placemark.administrativeArea)")
        NSLog("Country: \(placemark.country)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "getToSelectTagsSegue") {
            var passedValue = segue.destinationViewController as! SelectTagViewController;
            passedValue.toPass = PickerSelected.selectedNumber   
        }
    }

}

