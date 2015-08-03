//
//  ViewController.swift
//  circles
//
//  Created by Roman on 13/07/15.
//  Copyright (c) 2015 rshev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circlesView: Circles! {
        didSet {
            circlesView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapSwitch(sender: UISwitch) {
        circlesView.allowTapSelect = sender.on
    }

}

extension ViewController: CirclesDelegate {
    func circlesSelectedOrbit(circles: Circles, selectedOrbitNumber: UInt) {
        println(selectedOrbitNumber)
    }
}
