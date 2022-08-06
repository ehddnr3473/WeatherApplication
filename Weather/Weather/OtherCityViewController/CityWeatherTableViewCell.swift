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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpHierachy()
        setUpLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func setUpHierachy() {
        [backgroundImageView, cityNameLabel, weatherLabel, temperatureLabel].forEach {
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
            weatherLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            weatherLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
