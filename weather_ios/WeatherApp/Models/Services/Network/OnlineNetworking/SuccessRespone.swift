//
//  SuccessRespone.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

public struct SuccessRespone: Decodable, WeatherModel {
    let coord: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

public struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

public struct Main: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

public struct Wind: Decodable {
    let speed: Double
    let deg: Double
}

public struct Clouds: Decodable {
    let all: Int
}

public struct Sys: Decodable {
    let type: Int
    let id: Int
    let message: Double?
    let country: String
    let sunrise: Int
    let sunset: Int
}
