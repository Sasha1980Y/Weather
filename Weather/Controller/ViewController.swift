//
//  ViewController.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/13/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


class ViewController: UIViewController, LoaderDelegate , TableViewDelegate {
    
    
    
    

    @IBOutlet weak var tableView: UITableView!
    
    let loader = Loader()
    
    //var arrayOfCity = ["Вінниця", "Київ"]
    
    var openWeatherArray: [OpenWeather]?
    
    var numberSelectedCell: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            
            fillArray()
            
            // delegate Loader
            loader.delegate = self
            loader.tableViewDelegate = self
            
            
        } else {
            print("internet is unavailable")
        }
        
        
        let disposeBag = DisposeBag()
        Loader.shared.arrayModels.asObservable().subscribe(onNext: { (arrayOfModels) in
            //self.tableView.reloadData()
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("ok rx")
        }, onDisposed: {
            
        }).disposed(by: disposeBag)
        
    }
    
    func downloadJSON(city: String, position: Int) {
        loader.downloadJSON(city: city, position: position)
        print("ok downloadJSON")
        //self.tableView.reloadData()
    }
    
    func downloadForecast(id: Int) {
        //loader.downloadForecast(id: id)
        //self.view.layoutIfNeeded()
    }
    
    func refreshTable() {
        self.tableView.reloadData()
    }
    
    

    func fillArray() {
        /*
        let object = OpenWeather(weather: [OpenWeather.Weather.init(description: "snown")], main: OpenWeather.Main.init(temp: 272, pressure: 1000, humidity: 80), wind: OpenWeather.Wind.init(speed: 4.3), id: 333999, name: "London")
        let object2 = OpenWeather(weather: [OpenWeather.Weather.init(description: "rained")], main: OpenWeather.Main.init(temp: 270, pressure: 1200, humidity: 90), wind: OpenWeather.Wind.init(speed: 4.4), id: 333999, name: "London")
        
        Loader.shared.arrayModels.value.append(Model(city: "Вінниця", openWeather: object))
        Loader.shared.arrayModels.value.append(Model(city: "Київ", openWeather: object2))
        */
        
        Loader.shared.arrayModels.value.append(Model(city: "Вінниця", openWeather: nil))
        Loader.shared.arrayModels.value.append(Model(city: "Київ", openWeather: nil))
        
    }

    @IBAction func plusButtton() {
        alertForPlusButton()
    }
    
    func alertForPlusButton() {
        let alert = UIAlertController(title: nil, message: "Add city", preferredStyle: .alert)
        alert.addTextField { (tf) in
            //tf.keyboardType = UIKeyboardType.decimalPad
        }
        let action = UIAlertAction(title: "OK", style: .default) { [weak alert](_) in
            let textField = alert?.textFields![0]
            if let text = textField?.text {
                Loader.shared.arrayModels.value.append(Model(city: text, openWeather: nil))
                self.tableView.reloadData()
                
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let vc = segue.destination as! DetailViewController
            vc.title = "Detail Weather"
            if let number = numberSelectedCell {
                vc.city = Loader.shared.arrayModels.value[number].city
                vc.index = number
            }
            
        }
    }
    

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Loader.shared.arrayModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        if (Loader.shared.arrayModels.value[indexPath.row].openWeather == nil) {
            loader.startDownload(city: Loader.shared.arrayModels.value[indexPath.row].city, position: indexPath.row)
        } else {
            
        }
        
        cell.cityLabel.text = Loader.shared.arrayModels.value[indexPath.row].city
        cell.detailButton.addTarget(self, action: #selector(tapToButton(sender:)), for: .touchUpInside)
        if let temperature = Loader.shared.arrayModels.value[indexPath.row].openWeather?.main?.temp {
            cell.temperatureLabel.text = String(temperature)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            Loader.shared.arrayModels.value.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func tapToButton(sender: UIButton) {
        print("ok button")
        if let cell = sender.superview?.superview as? TableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            numberSelectedCell = indexPath?.row
            
        }
        performSegue(withIdentifier: "Detail", sender: nil)
        
    }
    
}

