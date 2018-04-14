//
//  ViewController.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/13/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LoaderDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    let loader = Loader()
    
    //var arrayOfCity = ["Вінниця", "Київ"]
    
    
    
    var openWeatherArray: [OpenWeather]?
    
    var numberSelectedCell: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillArray()
        
        // delegate Loader
        loader.delegate = self
        //loader.startDownload(city: "London")
        
    }
    
    func downloadJSON(city: String, position: Int) {
        loader.downloadJSON(city: city, position: position)
        print("ok")
    }

    func fillArray() {
        Loader.shared.arrayModels.append(Model(city: "Вінниця", openWeather: nil))
        Loader.shared.arrayModels.append(Model(city: "Київ", openWeather: nil))
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
                Loader.shared.arrayModels.append(Model(city: text, openWeather: nil))
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
                vc.city = Loader.shared.arrayModels[number].city
                vc.index = number
            }
            
            
            
        }
    }
    

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Loader.shared.arrayModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        if (Loader.shared.arrayModels[indexPath.row].openWeather != nil) {
            loader.startDownload(city: Loader.shared.arrayModels[indexPath.row].city, position: indexPath.row)
        }
        
        
        
        
        cell.cityLabel.text = Loader.shared.arrayModels[indexPath.row].city
        cell.detailButton.addTarget(self, action: #selector(tapToButton(sender:)), for: .touchUpInside)
        if let temperature = Loader.shared.arrayModels[indexPath.row].openWeather?.main?.temp {
            cell.temperatureLabel.text = String(temperature)
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            Loader.shared.arrayModels.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func tapToButton(sender: UIButton) {
        print("ok")
        if let cell = sender.superview?.superview as? TableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            numberSelectedCell = indexPath?.row
            
        }
        performSegue(withIdentifier: "Detail", sender: nil)
        
    }
    
}

