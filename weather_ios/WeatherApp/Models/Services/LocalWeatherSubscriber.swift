//
//  LocalWeatherManager.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation
import UIKit

@objc protocol LocalWeatherSubscriber: NSObjectProtocol { }

extension LocalWeatherSubscriber where Self: ViewController {
    func coordinateUpdateListener() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateWeather),
                                               name: Constants.locationIsLoad,
                                               object: nil)
    }
    
    func fetchWeather(_ notification: Notification) {
        
        guard let lat = notification.userInfo?[Constants.lat] as? Double,
            let lon = notification.userInfo?[Constants.lon] as? Double else { return }
        
        network?.getWeatherAt(coordinates: Coordinate(lat: lat,
                                                      lon: lon)) { [weak self] result, _ in
            guard let weather = result else { return }
            self?.localWeather = weather
        }
    }
}
