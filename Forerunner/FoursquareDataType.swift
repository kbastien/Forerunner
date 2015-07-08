//
//  FoursquareDataType.swift
//  Forerunner
//
//  Created by Kevin Bastien on 7/7/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import Foundation
import UIKit

class FoursquareDataType {
    var name: String?
    var category: String?
    var long: Int?
    var lat: Int?
    
    init () {}
    
    init(name: String?, category: String?, lat: Int?, long: Int?) {
        self.name = name
        self.category = category
        self.lat = lat
        self.long = long
    }
}