//
//  City.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation
import CoreData

@objc(City)
class City: NSManagedObject, Decodable, CityModel {
    
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var lat: NSNumber
    @NSManaged var lon: NSNumber
    @NSManaged var temp: NSNumber
    @NSManaged var tempMin: NSNumber
    @NSManaged var tempMax: NSNumber
    @NSManaged var condition: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, coord, lat, lon, main,temp, tempMin, tempMax, weather, condition
    }
    
    // MARK: - Decodable + CoreData
    required convenience init(from decoder: Decoder) throws {

        let context = CoreData.shared.cityUpdateContext
        guard let entity = NSEntityDescription.entity(forEntityName: "City",
                                                      in: context) else {
            fatalError("Failed to decode City")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let idInt = try container.decodeIfPresent(Int.self, forKey: .id) {
            id = NSNumber(value: idInt)
        }
        
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
       
        if let coord = try container.decodeIfPresent(Coordinate.self, forKey: .coord) {
            lat = NSNumber(value: coord.lat)
            lon = NSNumber(value: coord.lon)
        }

        if let main = try container.decodeIfPresent(Main.self, forKey: .main) {
            temp = NSNumber(value: round(main.temp))
            tempMin = NSNumber(value: round(main.tempMin))
            tempMax = NSNumber(value: round(main.tempMax))
        }

        if let weather = try container.decodeIfPresent([Weather].self, forKey: .weather) {
            condition = weather.first?.main ?? ""
        }
    }
}
