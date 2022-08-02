//
//  WeekLongWeatherTableViewCell.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/02.
//

import Foundation
import UIKit

class WeekLongWeatherTableViewCell: UITableViewCell {
    static let identifier: String = "WeekLongWeatherTableViewCell"
    
    lazy var dayLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var rateStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
    lazy var weatherImageVIew: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var rateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var extremeTemperatureStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
    lazy var highestTemperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var lowestTemperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
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
        [dayLabel, rateStackView, self.extremeTemperatureStackView].forEach {
            contentView.addSubview($0)
        }
        [self.lowestTemperatureLabel, self.highestTemperatureLabel].forEach {
            self.extremeTemperatureStackView.addArrangedSubview($0)
        }
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dayLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            rateStackView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 8),
            rateStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rateStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            self.extremeTemperatureStackView.leadingAnchor.constraint(equalTo: rateStackView.trailingAnchor, constant: 15),
            self.extremeTemperatureStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.extremeTemperatureStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
}
