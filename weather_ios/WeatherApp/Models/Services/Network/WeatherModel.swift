//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation

protocol WeatherModel {
    // swiftlint:disable identifier_name
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
    var icon: String? {
        guard let id = weather.first?.id,
            let icon = weather.first?.icon else { return nil }
        
        let prefix = icon.range(of: "n") == nil ? "day": "night"

        return IconType(rawValue: prefix + String(id))?.description
    }
}
