//
//  Loader.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/13/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import Foundation

protocol LoaderDelegate: class {
    func downloadJSON(city: String, position: Int)
}

class Loader {
    
    static var  shared = Loader()
    
    weak var delegate: LoaderDelegate?
    
    var arrayModels: [Model] = []
    
    static var openWeather: [OpenWeather] = []
    
    func startDownload(city: String, position: Int) {
        delegate?.downloadJSON(city: city, position: position)
    }
    
    func downloadJSON(city: String, position: Int) {
        let stringUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&APPID=fdb15c63cfbcef4adc9d97f6e5b2e106"
        // cann save api key to KeyChain
        guard let encoded = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("problem url")
            return
        }
        
        guard let url = URL(string: encoded) else { // stringUrl
            print("url problem")
            return
        }
        
        
        
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            print("ok")
            guard let data = data else {
                return
            }
            guard error == nil else {
                print("error = ", error)
                return
            }
            
            do {
                let json = try JSONDecoder().decode(OpenWeather.self, from: data)
                /*
                DispatchQueue.main.async {
                    Loader.shared.arrayModels[position].openWeather = json
                    
                }*/
                
                DispatchQueue.main.async {
                    Loader.shared.arrayModels[position].openWeather = json
                }
                
                
            } catch let error {
                print(error)
            }
            }.resume()
    }
}
