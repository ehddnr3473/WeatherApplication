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
    
    var todayStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
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
        [todayStackView].forEach {
            contentView.addSubview($0)
        }
        [timeLabel, weatherImageView, weatherLabel, temperatureLabel].forEach {
            todayStackView.addArrangedSubview($0)
        }
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            todayStackView.topAnchor.constraint(equalTo: self.topAnchor),
            todayStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            todayStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            todayStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
