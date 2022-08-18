//
//  WeekLongWeatherTableViewCell.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/02.
//

import Foundation
import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    static let identifier: String = "WeatherForecastTableViewCell"
    private var forecast: Forecast?
    
    var dayLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    var forecastCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        
        let collectionVIew: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionVIew.translatesAutoresizingMaskIntoConstraints = false
        
        collectionVIew.backgroundColor = UIColor.clear
        
        collectionVIew.register(TodayWeatherForecastCollectionViewCell.self, forCellWithReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier)
        
        return collectionVIew
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpHierachy()
        setUpLayout()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let forecast = forecast else {
            return
        }
        prepare(forecast: forecast)
    }
    
    func prepare(forecast: Forecast) {
        self.forecast = forecast
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpHierachy() {
        [dayLabel, forecastCollectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            
            forecastCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            forecastCollectionView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 5),
            forecastCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            forecastCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension WeatherForecastTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func configure() {
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let forecast = forecast else { return UICollectionViewCell() }
        
        cell.timeLabel.text = AppText.getTimeText(time: forecast.list[indexPath.row].time)
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: forecast.list[indexPath.row].weather[0].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = forecast.list[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(forecast.list[indexPath.row].main.temp)) + AppText.celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecast == nil {
            return 0
        } else {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}
