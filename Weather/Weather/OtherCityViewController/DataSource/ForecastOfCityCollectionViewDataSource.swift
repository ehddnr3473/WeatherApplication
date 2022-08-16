//
//  CityCollectionViewDataSource.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/13.
//

import Foundation
import UIKit

class ForecastOfCityCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private let celsiusString: String = "℃"
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        
        cell.timeLabel.text = AppText.getTimeText(time: OtherCityViewController.forecasts[CityWeatherTableViewDataSource.indexPathOfTableView].list[indexPath.row].time)
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: OtherCityViewController.forecasts[CityWeatherTableViewDataSource.indexPathOfTableView].list[indexPath.row].weather[0].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = OtherCityViewController.forecasts[CityWeatherTableViewDataSource.indexPathOfTableView].list[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(OtherCityViewController.forecasts[CityWeatherTableViewDataSource.indexPathOfTableView].list[indexPath.row].main.temp)) + celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if OtherCityViewController.forecasts.isEmpty {
            return 0
        } else {
            return 8
        }
    }
}
