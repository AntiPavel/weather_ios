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
    @NSManaged var temp: NSNumber
    @NSManaged var condition: String
    @NSManaged var descript: String
    @NSManaged var icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, main, weather
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

        if let main = try container.decodeIfPresent(Main.self, forKey: .main) {
            temp = NSNumber(value: round(main.temp))
        }

        if let weather = try container.decodeIfPresent([Weather].self, forKey: .weather) {
            condition = weather.first?.main ?? ""
            descript = weather.first?.description ?? ""
            
            if let id = weather.first?.id,
                let iconStr = weather.first?.icon {
                    let prefix = iconStr.range(of: "n") == nil ? "day": "night"
                    icon = IconType(rawValue: prefix + String(id))?.description ?? ""
            }
        }
    }
}
