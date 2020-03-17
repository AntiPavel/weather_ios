//
//  StorageService.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//
// swiftlint:disable identifier_name
import Foundation

protocol StorageService {
    
    func save()
    func fetchCities() -> [CityModel]
    func deleteCity(id: Int)
    func cleanCities()
}
