//
//  weatherForecastTableViewDataSource.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/12.
//

import Foundation
import UIKit

class WeatherForecastTableViewDataSource: NSObject, UITableViewDataSource {
    private let titleForWeatherForecastTableViewHeader: String = "3일간의 예보"
    static var indexPathOfTableView: IndexPath?
    var dayList: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ViewController.forecasts.isEmpty {
            return 0
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCell.identifier, for: indexPath) as? WeatherForecastTableViewCell else { return UITableViewCell() }
        WeatherForecastTableViewDataSource.indexPathOfTableView = indexPath
        cell.dayLabel.text = dayList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForWeatherForecastTableViewHeader
    }
}
