//
//  FewDaysViewController.swift
//  Weather
//
//  Created by Alexander Yakovenko on 4/15/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit

class FewDaysViewController: UIViewController, LoaderDelegate, CollectionViewDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var id = 0
    var cityLabelText = ""
    
    var arrayForCollectionView: [Forecast.List] = [] //Loader.shared.arrayForecast?.list
    
    let loader = Loader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityLabel.text = cityLabelText
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loader.delegate = self
        loader.collectionViewDelegate = self
        
        downloadForecast(id: id)
    
    }
    
    func downloadJSON(city: String, position: Int) {
        
    }
    
    func downloadForecast(id: Int) {
        loader.downloadForecast(id: id)
        
        //self.collectionView.reloadData()
    }
    
    func refreshCollectionView() {
        self.collectionView.reloadData()
    }

}

extension FewDaysViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Loader.shared.arrayForecast
            .filter {
               compareDate(date: $0.dt_txt!)
        }.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        
        cell.dateLabel.text = Loader.shared.arrayForecast.filter {compareDate(date: $0.dt_txt!)}[indexPath.row].dt_txt
        cell.tempLabel.text = String((Loader.shared.arrayForecast.filter {compareDate(date: $0.dt_txt)}[indexPath.row].main?.temp)!)
        cell.pressuerLabel.text = String((Loader.shared.arrayForecast.filter {compareDate(date: $0.dt_txt)}[indexPath.row].main?.pressure)!)
        cell.humidityLabel.text = String((Loader.shared.arrayForecast.filter {compareDate(date: $0.dt_txt)}[indexPath.row].main?.humidity)!)
        cell.descriptionLabel.text = (Loader.shared.arrayForecast.filter {compareDate(date: $0.dt_txt)}[indexPath.row].weather?.description)
        
        
        return cell
    }
    
    func compareDate(date: String?) -> Bool {
        
        //let str = "2017-01-30 18:00:00"
        
        if date != nil {
            let index = date!.index(date!.startIndex, offsetBy: 13)
            
            let strFromArray = date![..<index]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let today1 = Date()
            let today2 = Calendar.current.date(byAdding: .day, value: 1, to: today1)
            let today3 = Calendar.current.date(byAdding: .day, value: 2, to: today1)
            
            let dateFormToday1 = dateFormatter.string(from: today1) + " 12"
            let dateFormToday2 = dateFormatter.string(from: today2!) + " 12"
            let dateFormToday3 = dateFormatter.string(from: today3!) + " 12"
            
            if (strFromArray == dateFormToday1 || strFromArray == dateFormToday2 || strFromArray == dateFormToday3)
            {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
        
    }

}


