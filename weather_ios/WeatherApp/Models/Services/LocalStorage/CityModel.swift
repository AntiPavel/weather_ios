//
//  CityModel.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//
// swiftlint:disable identifier_name
import Foundation

protocol CityModel {
    
    var id: NSNumber { get }
    var name: String { get }
    var temp: NSNumber { get }
    var condition: String { get }
    var descript: String { get }
    var icon: String { get }
}
