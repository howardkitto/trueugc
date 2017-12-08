//
//  ViewController.swift
//  trueugc
//
//  Created by Howard Kitto on 08/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
     @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startButtonPressed(){
        infoLabel.text="connecting stream"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

