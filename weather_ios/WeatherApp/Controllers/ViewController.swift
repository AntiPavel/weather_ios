//
//  ViewController.swift
//  WeatherApp
//
//  Created by paul on 14/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        OpenWeatherMapNetwork().getWeatherAt(city: 2867714) { _,_  in
            
        }
    }

}
