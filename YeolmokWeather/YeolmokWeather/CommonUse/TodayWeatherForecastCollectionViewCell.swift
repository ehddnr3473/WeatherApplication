//
//  TodayWeatherForecastCollectionViewCell.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/08.
//

import Foundation
import UIKit

/// 예보 CollectionView를 위한 공용 Custom Cell
final class TodayWeatherForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "TodayWeatherForecastCollectionViewCell"
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = NSTextAlignment.center
        label.textColor = AppStyles.Colors.mainColor
        label.font = .boldSystemFont(ofSize: LayoutConstants.fontSize)
        
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = AppStyles.Colors.mainColor
        
        return imageView
    }()
    
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = AppStyles.Colors.mainColor
        label.font = .boldSystemFont(ofSize: LayoutConstants.fontSize)
        
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = AppStyles.Colors.mainColor
        label.font = .boldSystemFont(ofSize: LayoutConstants.fontSize)
        
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
    
    private func setUpHierachy() {
        [timeLabel, weatherImageView, weatherLabel, temperatureLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstants.offset),
            
            weatherImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: LayoutConstants.smallOffset),
            weatherImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: LayoutConstants.imageWidth),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor),
            
            weatherLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: LayoutConstants.smallOffset),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -LayoutConstants.offset)
        ])
    }
}

private enum LayoutConstants {
    static let smallOffset: CGFloat = 5
    static let offset: CGFloat = 10
    static let imageWidth: CGFloat = 0.3
    static let fontSize: CGFloat = 10
}
