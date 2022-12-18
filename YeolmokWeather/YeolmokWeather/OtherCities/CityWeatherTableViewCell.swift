//
//  CityWeatherTableViewCell.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/07.
//

import Foundation
import UIKit
import CoreData

/// 각 도시의 현재 날씨와 약 24시간 동안의 예보를 나타내는 Custom Cell
final class CityWeatherTableViewCell: UITableViewCell {
    static let identifier = "CityWeatherTableViewCell"
    private var forecast: Forecast?
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = .lightGray
        button.setImage(UIImage(named: ImageName.star)?.withRenderingMode(.alwaysTemplate),
                        for: UIControl.State.normal)
        button.addTarget(self, action: #selector(touchUpBookmarkButton(_:)), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = AppStyles.Colors.mainColor
        label.font = .boldSystemFont(ofSize: LayoutConstants.mediumFontSize)
        
        return label
    }()
    
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = AppStyles.Colors.mainColor
        label.font = .boldSystemFont(ofSize: LayoutConstants.smallFontSize)
        
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = AppStyles.Colors.mainColor
        label.font = .boldSystemFont(ofSize: LayoutConstants.largeFontSize)
        
        return label
    }()
    
    let forecastOfCityCollectionView: UICollectionView = {
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
        
        bookmarkButton.setImage(UIImage(named: ImageName.star)?.withRenderingMode(.alwaysTemplate),
                                for: UIControl.State.normal)
        bookmarkButton.tintColor = .lightGray
        bookmarkButton.isSelected = false
    }
    
    func setUpForecast(forecast: Forecast) {
        self.forecast = forecast
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpHierachy() {
        [bookmarkButton, cityNameLabel, weatherLabel, temperatureLabel, forecastOfCityCollectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstants.offset),
            bookmarkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstants.offset),
            bookmarkButton.widthAnchor.constraint(equalToConstant: LayoutConstants.bookmarkSize),
            bookmarkButton.heightAnchor.constraint(equalToConstant: LayoutConstants.bookmarkSize),
            
            cityNameLabel.topAnchor.constraint(equalTo: bookmarkButton.topAnchor),
            cityNameLabel.leadingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor, constant: LayoutConstants.offset),
            
            weatherLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: LayoutConstants.offset),
            weatherLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstants.offset),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -LayoutConstants.offset),
            temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -LayoutConstants.quarterOfCenterY),
            
            forecastOfCityCollectionView.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor),
            forecastOfCityCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            forecastOfCityCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            forecastOfCityCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configure() {
        forecastOfCityCollectionView.dataSource = self
        forecastOfCityCollectionView.delegate = self
    }
    
    @objc func touchUpBookmarkButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.tintColor = .systemYellow
            BookmarkManager.saveCity(name: cityNameLabel.text ?? "")
        } else {
            sender.tintColor = .lightGray
            BookmarkManager.deleteCity(name: cityNameLabel.text ?? "")
        }
    }
}

extension CityWeatherTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let forecast = forecast else { return cell }
        
        let time = Date(timeIntervalSince1970: forecast.list[indexPath.row].date)
            .formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)))
        
        cell.timeLabel.text = time
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
        return CGSize(width: NumberConstants.sizeOfItem, height: NumberConstants.sizeOfItem)
    }
}

// MARK: - Magic Number
private enum LayoutConstants {
    static let offset: CGFloat = 15
    static let bookmarkSize: CGFloat = 30
    static let quarterOfCenterY: CGFloat = 50
    static let largeFontSize: CGFloat = 40
    static let mediumFontSize: CGFloat = 30
    static let smallFontSize: CGFloat = 20
}

private enum NumberConstants {
    static let numberOfItem = 8
    static let sizeOfItem = 100
}

private enum ImageName {
    static let star = "star"
}
