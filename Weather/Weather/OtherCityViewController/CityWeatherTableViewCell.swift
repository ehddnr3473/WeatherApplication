//
//  CityWeatherTableViewCell.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/07.
//

import Foundation
import UIKit

class CityWeatherTableViewCell: UITableViewCell {
    static let identifier: String = "CityWeatherTableViewCell"
    private let celsiusString: String = "℃"
    
    // 날씨 백그라운드 이미지뷰, 도시이름 레이블, 날씨 레이블, 온도 레이블
    var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var cityNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    var weatherLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func setUpHierachy() {
        [backgroundImageView, cityNameLabel, weatherLabel, temperatureLabel, forecastCollectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            cityNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            cityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            weatherLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 15),
            weatherLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -75),
            
            forecastCollectionView.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor),
            forecastCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            forecastCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            forecastCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
    }
}

extension CityWeatherTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func configure() {
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        cell.timeLabel.text = FetchTimeText.getTimeText(time: OtherCityViewController.forecasts[ViewController.count].list[indexPath.row].time)
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: OtherCityViewController.forecasts[ViewController.count].list[indexPath.row].weather[0].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = OtherCityViewController.forecasts[ViewController.count].list[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(OtherCityViewController.forecasts[ViewController.count].list[indexPath.row].main.temp)) + celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if OtherCityViewController.forecasts.isEmpty {
            return 0
        } else {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 150)
    }
}
