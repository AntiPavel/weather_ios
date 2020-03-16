//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation

protocol WeatherModel {
    
    var id: Int { get }
    var name: String { get }
    var temp: Int { get }
    var condition: String { get }
    var description: String { get }
    var coord: Coordinate { get }
    var main: Main { get }
    var weather: [Weather] { get }
}

extension WeatherModel {
    var temp: Int {
        return Int(round(main.temp))
    }
    var condition: String {
        return weather.first?.main ?? ""
    }
    var description: String {
        return weather.first?.description ?? ""
    }
}
