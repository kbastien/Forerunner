//
//  SelectTagViewController.swift
//  Forerunner
//
//  Created by Kevin Bastien on 6/17/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit

class SelectTagViewController: UIViewController {
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocationLabel.text = "Portland, OR"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}