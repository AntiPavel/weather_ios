//
//  ViewController.swift
//  WeatherApp
//
//  Created by paul on 14/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LocalWeatherSubscriber {
    
    private var appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var network: NetworkService? = appDelegate?.network
    lazy var storage: StorageService? = appDelegate?.storage
    lazy var location: LocationManager? = appDelegate?.location

    @IBOutlet weak var bottomTemp: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // bottomTemp.text = localWeather?.description
        // Do any additional setup after loading the view.
//        OpenWeatherMapNetwork().getWeatherAt(city: 2867714) { result,_  in
//
//            let context = CoreData.shared.cityUpdateContext
//
//            guard context.hasChanges else { return }
//
//            do {
//                try context.save()
//                print("context.save() success")
//            } catch let saveError {
//                fatalError("Unresolved error: \(saveError), \(saveError.localizedDescription)")
//            }
//        }
        coordinateUpdateListener()
        location?.startUpdateLocation()
//        OpenWeatherMapNetwork().getWeatherAt(city: "Moscow") { result, _ in
//            
//        }
    }
    
    var localWeather: WeatherModel? {
        didSet {
            bottomTemp.text = localWeather?.description
        }
    }
    
    @objc func updateWeather(notification: Notification) {
        fetchWeather(notification)
    }
}
