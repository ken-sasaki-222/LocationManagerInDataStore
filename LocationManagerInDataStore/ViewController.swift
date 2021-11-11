//
//  ViewController.swift
//  LocationManagerInDataStore
//
//  Created by sasaki.ken on 2021/11/11.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapGpsButton(_ sender: UIButton) {
        print("kenken")
    }
    
}

