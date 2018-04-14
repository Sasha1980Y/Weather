//
//  JSON.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/13/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import Foundation

struct JSON: Decodable {
    
    var query: Query?
    struct Query: Decodable {
        var count: Int?
        var created: String?
        var lang: String?
        var results: Results?
        struct Results: Decodable {
            var channel: Channel?
            struct Channel: Decodable {
                var units: Units?
                struct Units: Decodable {
                    
                }
                var title: String?
                var link: String?
                var location: Location?
                struct Location: Decodable {
                    
                }
                var wind: Wind?
                struct Wind: Decodable {
                    
                }
                var atmosphere: Atmosphere?
                struct Atmosphere: Decodable {
                    
                }
                var image: Image?
                struct Image: Decodable {
                    
                }
                var item: Item?
                struct Item: Decodable {
                    var title: String?
                    var forecast: [Forecast]?
                    struct Forecast: Decodable {
                        var date: String?
                        var text: String?
                    }
                }
                
            }
        }
    }
    
    
}

