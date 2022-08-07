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
    
    var dayLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    var rateStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
    var weatherImageVIew: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var rateLabel: UILabel = {
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
        [dayLabel, rateStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dayLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            rateStackView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 8),
            rateStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rateStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
        ])
    }
}
