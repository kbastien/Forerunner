//
//  SelectTagViewController.swift
//  Forerunner
//
//  Created by Kevin Bastien on 6/17/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class SelectTagViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView?
    
    var locationManager = CLLocationManager()
    var toPass:Int!
    var lat:CLLocationDegrees!
    var long:CLLocationDegrees!
    var cityState:String!
    var tableData = []
    var foursquareData = [FoursquareDataType]()
    
    let CLIENT_ID = "3FR3WRO5GNGGHG5DYSKTDGB1SDCV0PGLJT4WCI3GJDWI1DMS"
    let CLIENT_SECRET = "SZJPN1B5JARBOCWDVBN2T345UQSJ3TAGZWMGDZRQERBSAX5B"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocation()
        foursquareCall()
        self.currentLocationLabel.text = cityState
        NSLog("This is the number picked: %d", toPass)
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 90, height: 90)
//        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        collectionView!.dataSource = self
//        collectionView!.delegate = self
//        collectionView!.registerClass(categoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCollectionViewCell")
//        collectionView!.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(collectionView!)
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
    
    private func foursquareCall(){
        print("LATITUDE STRUCT ::: \(lat)")
        var postEndpoint: String = "https://api.foursquare.com/v2/venues/explore?client_id=" + CLIENT_ID + "&client_secret=" + CLIENT_SECRET + "&v=20130815&ll=\(lat),\(long)&limit=20"
        
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
                        self.foursquareData.append(FoursquareDataType(name: post["response"]["groups"][0]["items"][i-1]["venue"]["name"].string!, category: post["response"]["groups"][0]["items"][i-1]["venue"]["categories"][0]["pluralName"].string!, lat: post["response"]["groups"][0]["items"][i-1]["venue"]["location"]["lat"].int!, long:post["response"]["groups"][0]["items"][i-1]["venue"]["location"]["lng"].int!))
                        println("\(i)")
                        println("CATEGORY is: " + post["response"]["groups"][0]["items"][i-1]["venue"]["categories"][0]["pluralName"].string!)
                        println("Category is: \(self.foursquareData[i-1].category)")
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
    
    // 1
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.foursquareData.count
    }
    
    // 2
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: categoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! categoryCollectionViewCell
        cell.labelCell.text = self.foursquareData[indexPath.row].category
        println("WHAT IS THIS?!?! " + self.foursquareData[indexPath.row].category!)
        return cell
    }
    
    // 3
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell \(indexPath.row) selected")
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}