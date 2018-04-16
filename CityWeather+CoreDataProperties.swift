//
//  CityWeather+CoreDataProperties.swift
//  
//
//  Created by Alexander Yakovenko on 4/15/18.
//
//

import Foundation
import CoreData


extension CityWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeather> {
        return NSFetchRequest<CityWeather>(entityName: "CityWeather")
    }

    @NSManaged public var windSpeed: Double
    @NSManaged public var hudimity: Int16
    @NSManaged public var pressure: Double
    @NSManaged public var descriptionWeather: String?
    @NSManaged public var city: String?

}
