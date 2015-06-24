//
//  ViewController.swift
//  Forerunner
//
//  Created by Kevin Bastien on 6/16/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit

class GeneratedRouteViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

