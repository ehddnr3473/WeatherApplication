//
//  TodayWeatherForecastCollectionViewCell.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/08.
//

import Foundation
import UIKit

/// 예보 CollectionView를 위한 공용 Custom Cell
class TodayWeatherForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "TodayWeatherForecastCollectionViewCell"
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = NSTextAlignment.center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = .white
        
        return imageView
    }()
    
    var weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpHierachy()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpHierachy() {
        [timeLabel, weatherImageView, weatherLabel, temperatureLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstraint.standardGap),
            
            weatherImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: LayoutConstraint.smallGap),
            weatherImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: LayoutConstraint.imageWidth),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor),
            
            weatherLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: LayoutConstraint.smallGap),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -LayoutConstraint.standardGap)
        ])
    }
}

private enum LayoutConstraint {
    static let smallGap: CGFloat = 5
    static let standardGap: CGFloat = 10
    static let imageWidth: CGFloat = 0.3
}
