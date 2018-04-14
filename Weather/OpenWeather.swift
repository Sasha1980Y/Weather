//
//  OpenWeather.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/13/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import Foundation

struct OpenWeather: Decodable {
    var weather: [Weather]?
    struct Weather: Decodable {
        var description: String?
    }
    var main: Main?
    struct Main: Decodable {
        var temp: Float?
        var pressure: Float?
        var humidity: Int?
    }
    var wind: Wind?
    struct Wind: Decodable {
        var speed: Float?
        
    }
    var id: Int?
    var name: String?
    
}
