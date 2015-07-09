//
//  SelectTagViewController.swift
//  Forerunner
//
//  Created by Kevin Bastien on 6/17/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit
import CoreLocation

class SelectTagViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView?
    
    var locationManager = CLLocationManager()
    var toPass:Int!
    var cityState:String!
    var foursquareData: [FoursquareDataType]!
    
    struct hack {
        static var cellWidth: CGFloat?
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocation()
        self.currentLocationLabel.text = cityState
        NSLog("This is the number picked: %d", toPass)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 200, height: 120)
//        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
//        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
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
    
    // 1
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of items we want to show
        return 20
    }
    
    // 2
//    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellID", forIndexPath: indexPath) as Cell
//    cell.textLabel.text = array[indexPath.row]
//    cell.textLabel.sizeToFit()
//    
//    // Customize cell height
//    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, heights[indexPath.row])
//    return cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! categoryCollectionViewCell
        cell.labelCell.text = "\(foursquareData[indexPath.row].category!)"
        cell.backgroundColor = UIColor.orangeColor()
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.labelCell.intrinsicContentSize().width, cell.frame.size.height)
        return cell
    }
    
    // 3
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Cell \(indexPath.row) selected")
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}