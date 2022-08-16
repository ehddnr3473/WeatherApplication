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
    private var dataSources: [UICollectionViewDataSource] = []
    private let forecastCollectionViewDataSource = ForecastCollectionViewDataSource()
    
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
    
    required init?(coder: NSCoder) {
        fatalError("")
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

extension WeatherForecastTableViewCell: UICollectionViewDelegateFlowLayout {
    private func configure() {
        dataSources = [forecastCollectionViewDataSource]
        forecastCollectionView.dataSource = dataSources[0]
        forecastCollectionView.delegate = self
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 130)
    }
}
