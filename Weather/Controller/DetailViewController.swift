//
//  DetailViewController.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/13/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var contentDescriptionLabel: UILabel!
    
    @IBOutlet weak var contentPressureLabel: UILabel!
    
    @IBOutlet weak var contentHudimityLabel: UILabel!
    
    @IBOutlet weak var contentWindSpeeedLabel: UILabel!
    
    var city = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadInfo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadInfo() {
        cityLabel.text = city
        
        if Loader.shared.arrayModels.value[index].openWeather != nil {
            if (Loader.shared.arrayModels.value[index].openWeather?.weather) != nil {
                contentDescriptionLabel.text = Loader.shared.arrayModels.value[index].openWeather?.weather![0].description
            }
        }
        if Loader.shared.arrayModels.value[index].openWeather != nil {
            if (Loader.shared.arrayModels.value[index].openWeather?.main) != nil {
                if let pressure = Loader.shared.arrayModels.value[index].openWeather?.main?.pressure {
                    let pressureFloat = String(pressure)
                    contentPressureLabel.text = pressureFloat
                }
                
            }
        }
        if Loader.shared.arrayModels.value[index].openWeather != nil {
            if (Loader.shared.arrayModels.value[index].openWeather?.main) != nil {
                if let humidity = Loader.shared.arrayModels.value[index].openWeather?.main?.humidity {
                    let humidityInt = String(humidity)
                    contentHudimityLabel.text = humidityInt
                }
                
            }
        }
        if Loader.shared.arrayModels.value[index].openWeather != nil {
            if (Loader.shared.arrayModels.value[index].openWeather?.wind) != nil {
                if let windSpeed = Loader.shared.arrayModels.value[index].openWeather?.wind?.speed {
                    let speedFloat = String(windSpeed)
                    contentWindSpeeedLabel.text = speedFloat
                }
                
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
