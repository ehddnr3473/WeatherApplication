//
//  ForecastCollectionViewDataSource.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/12.
//

import Foundation
import UIKit

class ForecastCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let indexPathOfTableView = WeatherForecastTableViewDataSource.indexPathOfTableView else { return UICollectionViewCell() }
        
        cell.timeLabel.text = AppText.getTimeText(time: ViewController.forecasts[indexPathOfTableView.row].list[indexPath.row].time)
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: ViewController.forecasts[indexPathOfTableView.row].list[indexPath.row].weather[0].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = ViewController.forecasts[indexPathOfTableView.row].list[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(ViewController.forecasts[indexPathOfTableView.row].list[indexPath.row].main.temp)) + AppText.celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ViewController.forecasts.isEmpty {
            return 0
        } else {
            return 8
        }
    }
}
