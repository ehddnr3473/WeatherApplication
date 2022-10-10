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
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        
        return label
    }()
    var forecastCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .clear
        
        collectionView.register(TodayWeatherForecastCollectionViewCell.self, forCellWithReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier)
        
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpHierachy()
        setUpLayout()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        forecast = nil
    }
    
    func setUpForecast(with forecast: Forecast) {
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
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstraint.standardGap),
            
            forecastCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            forecastCollectionView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: LayoutConstraint.standardGap),
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
        guard let forecast = forecast else { return cell }
        
        cell.timeLabel.text = AppText.getTimeText(time: forecast.list[indexPath.row].time)
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: forecast.list[indexPath.row].weather[.zero].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = forecast.list[indexPath.row].weather[.zero].description
        cell.temperatureLabel.text = String(Int(forecast.list[indexPath.row].main.temp)) + AppText.celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecast == nil {
            return .zero
        } else {
            return NumberConstants.numberOfItem
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: NumberConstants.widthOfItem, height: NumberConstants.heightOfItem)
    }
}

private struct LayoutConstraint {
    static let standardGap: CGFloat = 8
}

private struct NumberConstants {
    static let numberOfItem = 8
    static let widthOfItem = 80
    static let heightOfItem = 100
}
