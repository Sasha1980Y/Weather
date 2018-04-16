//
//  DetailViewController.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/13/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var contentDescriptionLabel: UILabel!
    
    @IBOutlet weak var contentPressureLabel: UILabel!
    
    @IBOutlet weak var contentHudimityLabel: UILabel!
    
    @IBOutlet weak var contentWindSpeeedLabel: UILabel!
    
    @IBOutlet weak var enterCityTextField: UITextField!
    
    var city = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadInfo()
        
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
    
    @IBAction func saveToDataBase(_ sender: Any) {
        if cityLabel.text != "" {
            if let city = cityLabel.text {
                let description = contentDescriptionLabel.text
                
                var pressureDouble: Double = 222
                if let pressureText = contentPressureLabel.text {
                    if let pressureDoubleWrap = Double(pressureText) {
                        pressureDouble = pressureDoubleWrap
                        print(pressureDouble)
                    }
                }
                //let pressure = Double(contentPressureLabel.text)
                let hudimity = Int(contentHudimityLabel.text!)
                var windSpeedDouble: Double = 333
                
                if let windSpeedText = contentWindSpeeedLabel.text {
                    if let windSpeedDoubleWrap = Double(windSpeedText) {
                        windSpeedDouble = windSpeedDoubleWrap
                        print(windSpeedDouble)
                    }
                }
                
                saveToCoreData(city: city, description: description!, pressure: pressureDouble, hudimity: hudimity!, windSpeed: windSpeedDouble)
                
            }
        }
    }
    @IBAction func fetchFromDataBase(_ sender: Any) {
        if enterCityTextField.text == "" {
            print("you need enter city")
        } else {
            print(enterCityTextField.text)
            if let cityText = enterCityTextField.text {
                selectQuestion(city: cityText)
            }
        }
    }
    
    @IBAction func weatherForThreeDaysButton(_ sender: Any) {
        performSegue(withIdentifier: "FewDays", sender: nil)
    }
    
    
    // MARK: DataBase
    // save
    func saveToCoreData(city: String, description: String, pressure: Double, hudimity: Int, windSpeed: Double) {
        
        let context = CoreDataManager.instance.managedObjectContext
        // Описание сущности
        let entityDescription = NSEntityDescription.entity(forEntityName: "CityWeather", in: context)
        
        // Создание нового объекта
        let managedObject = CityWeather(entity: entityDescription!, insertInto: context)
        
        // managedObject це один запис до бази даних
        
        managedObject.city = city
        managedObject.descriptionWeather = description
        managedObject.pressure = pressure
        managedObject.hudimity = Int16(hudimity)
        managedObject.windSpeed = windSpeed
        
        // Запись объекта
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    // get Core Data
    func selectQuestion(city: String) {
        let context = CoreDataManager.instance.managedObjectContext
        let fetchRequest: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "city == %@", city)
        
        do {
            let array = try context.fetch(fetchRequest) as [CityWeather]
            
            cityLabel.text = array[0].city
            contentDescriptionLabel.text = array[0].descriptionWeather
            contentPressureLabel.text = String(array[0].pressure)
            contentHudimityLabel.text = String(array[0].hudimity)
            contentWindSpeeedLabel.text = String(array[0].windSpeed)
            
        } catch let errore {
            print("error FetchRequest \(errore)")
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FewDays" {
            let vc = segue.destination as! FewDaysViewController
            vc.title = "Few Days Weather"
            if let array = Loader.shared.arrayModels.value[index].openWeather {
                if let id = array.id {
                    vc.id = id
                }
            }
            if let city = cityLabel.text {
                vc.cityLabelText = city
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
