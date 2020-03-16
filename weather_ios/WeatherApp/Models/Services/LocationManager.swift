//
//  LocationManager.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager: CLLocationManager = CLLocationManager()
    var coordinates: Coordinate? {
        didSet {
            guard let coords = coordinates else { return }
            let params = [Constants.lat: coords.lat, Constants.lon: coords.lon]
            NotificationCenter.default.post(name: Constants.locationIsLoad,
                                            object: nil,
                                            userInfo: params)
        }
    }
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdateLocation() {
        manager.startUpdatingLocation()
    }
    
    private func stopUpdateLocation() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        coordinates = Coordinate(lat: location.coordinate.latitude,
                                 lon: location.coordinate.longitude)
        stopUpdateLocation()
    }
}
