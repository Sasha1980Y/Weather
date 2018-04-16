//
//  Forecast.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/15/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import Foundation

// Forecast

struct Forecast: Decodable {
    var list: [List]?
    struct List: Decodable {
        var main: Main?
        struct Main: Decodable {
            var temp: Double?
            var pressure: Double?
            var humidity: Int?
        }
        var weather: [Weather]?
        struct Weather: Decodable {
            var description: String?
        }
        var dt_txt: String?
    }
}
