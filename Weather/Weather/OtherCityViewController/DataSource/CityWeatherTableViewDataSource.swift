//
//  CityWeatherTableViewDataSource.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/12.
//

import Foundation
import UIKit

class CityWeatherTableViewDataSource: NSObject, UITableViewDataSource {
    var cities: [WeatherOfCity] = []
    static var indexPathOfTableView: Int = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherTableViewCell.identifier, for: indexPath) as? CityWeatherTableViewCell else {
            return UITableViewCell()
        }
        cell.cityNameLabel.text = cities[indexPath.row].name
        cell.weatherLabel.text = cities[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(cities[indexPath.row].main.temp))
        CityWeatherTableViewDataSource.indexPathOfTableView = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
}
