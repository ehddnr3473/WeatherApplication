//
//  TodayWeatherForecastCollectionViewCell.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/08.
//

import Foundation
import UIKit

class TodayWeatherForecastCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "TodayWeatherForecastCollectionViewCell"
    
    var timeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    var weatherImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = UIColor.white
        
        return imageView
    }()
    
    var weatherLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpHierachy()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUpHierachy() {
        [timeLabel, weatherImageView, weatherLabel, temperatureLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            
            weatherImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            weatherImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor),
            
            weatherLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 5),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
