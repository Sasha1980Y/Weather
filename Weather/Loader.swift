//
//  Loader.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/13/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import Foundation
import RxSwift

protocol LoaderDelegate: class {
    func downloadJSON(city: String, position: Int)
    func downloadForecast(id: Int)
    
}


protocol TableViewDelegate: class {
    func refreshTable()
}

protocol CollectionViewDelegate: class {
    func refreshCollectionView()
}


class Loader {
    
    static var  shared = Loader()
    
    weak var delegate: LoaderDelegate?
    
    var arrayModels: Variable<[Model]> = Variable([])
    
    static var openWeather: [OpenWeather] = []
    
    var arrayForecast: [Forecast.List] = []
    
    weak var tableViewDelegate: TableViewDelegate?
    
    weak var collectionViewDelegate: CollectionViewDelegate?
    
    func startDownload(city: String, position: Int) {
        delegate?.downloadJSON(city: city, position: position)
    }
    
    func startDownloadForecast(id: Int) {
        delegate?.downloadForecast(id: id)
    }
    
    func downloadJSON(city: String, position: Int) {
        
        //let object = OpenWeather(weather: [OpenWeather.Weather.init(description: "not download")], main: OpenWeather.Main.init(temp: 0, pressure: 0, humidity: 0), wind: OpenWeather.Wind.init(speed: 0), id: 0, name: "")
        
        //Loader.shared.arrayModels.value[position].openWeather = object
        
        let stringUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&APPID=bd5e378503939ddaee76f12ad7a97608"
        // "&APPID=ea574594b9d36ab688642d5fbeab847e"
        //  "&APPID=fdb15c63cfbcef4adc9d97f6e5b2e106"
        // bd5e378503939ddaee76f12ad7a97608
        
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
            
            print("ok Loader dataTask")
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
                    let object = OpenWeather(weather: [OpenWeather.Weather.init(description: "snown")], main: OpenWeather.Main.init(temp: 272, pressure: 1000, humidity: 80), wind: OpenWeather.Wind.init(speed: 4.3), id: 333999, name: "London")
                    
                    Loader.shared.arrayModels.value[position].openWeather = json
                    
                    self.tableViewDelegate?.refreshTable()
                }
                
                
                } catch let error {
                    print(error)
                
                }
            }.resume()
    }
    
    
    
    func downloadForecast(id: Int) {
        
        let stringId = String(describing: id)
        let stringUrl = "https://api.openweathermap.org/data/2.5/forecast?id=\(stringId)&APPID=bd5e378503939ddaee76f12ad7a97608"
        print("id", id)
        
        //  "&APPID=fdb15c63cfbcef4adc9d97f6e5b2e106"
        //  "&APPID=ea574594b9d36ab688642d5fbeab847e"
        // bd5e378503939ddaee76f12ad7a97608
        
        // cann save api key to KeyChain
        guard let encoded = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { //urlFragmentAllowed
            print("problem url")
            return
        }
        
    
        
        guard let url = URL(string: encoded) else { // stringUrl
            print("url problem")
            return
        }
        
        
        
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            print("ok Loader dataTask")
            guard let data = data else {
                return
            }
            guard error == nil else {
                print("error = ", error)
                return
            }
            
            do {
                let json = try JSONDecoder().decode(Forecast.self, from: data)
            
                DispatchQueue.main.async {
                    
                    if let jsonList = json.list {
                        
                        
                        Loader.shared.arrayForecast = jsonList
                        self.collectionViewDelegate?.refreshCollectionView()
                    }
           
                }
                
                
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    
    
    
}
