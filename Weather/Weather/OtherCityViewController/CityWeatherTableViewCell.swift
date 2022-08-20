//
//  CityWeatherTableViewCell.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/07.
//

import Foundation
import UIKit
import CoreData

class CityWeatherTableViewCell: UITableViewCell {
    static let identifier: String = "CityWeatherTableViewCell"
    var cities: [WeatherOfCity] = []
    private var forecast: Forecast?
    
    // 날씨 백그라운드 이미지뷰, 도시이름 레이블, 날씨 레이블, 온도 레이블
    var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var bookMarkButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = UIColor.lightGray
        button.setImage(UIImage(named: "star")?.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(touchUpBookMarkButton(_:)), for: UIControl.Event.touchUpInside)
        
        return button
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
    
    var forecastOfCityCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor.clear
        
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
        guard let forecast = forecast else {
            return
        }
        prepare(forecast: forecast)
    }
    
    func prepare(forecast: Forecast) {
        self.forecast = forecast
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpHierachy() {
        [backgroundImageView, bookMarkButton, cityNameLabel, weatherLabel, temperatureLabel, forecastOfCityCollectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            bookMarkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            bookMarkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            bookMarkButton.widthAnchor.constraint(equalToConstant: 30),
            bookMarkButton.heightAnchor.constraint(equalTo: bookMarkButton.widthAnchor),
            
            cityNameLabel.topAnchor.constraint(equalTo: bookMarkButton.topAnchor),
            cityNameLabel.leadingAnchor.constraint(equalTo: bookMarkButton.trailingAnchor, constant: 10),
            
            weatherLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 15),
            weatherLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
            
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
    
    @IBAction func touchUpBookMarkButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.tintColor = UIColor.systemYellow
            saveCity(name: cityNameLabel.text ?? "")
        } else {
            sender.tintColor = UIColor.lightGray
            deleteCity(name: cityNameLabel.text ?? "")
        }
    }
}

extension CityWeatherTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let forecast = forecast else { return UICollectionViewCell() }
        
        cell.timeLabel.text = AppText.getTimeText(time: forecast.list[indexPath.row].time)
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: forecast.list[indexPath.row].weather[0].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = forecast.list[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(forecast.list[indexPath.row].main.temp)) + AppText.celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecast == nil {
            return 0
        } else {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

// MARK: - CoreData
extension CityWeatherTableViewCell {
    private func saveCity(name: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }

        guard let entity = NSEntityDescription.entity(forEntityName: "City", in: context) else { return }

        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(name, forKey: "name")
        
        do {
            try context.save()
            print(object)
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    
    func deleteCity(name: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "City")

        fetchRequest.predicate = NSPredicate(format: "name = %@ ", name)

        do {
            let result = try context.fetch(fetchRequest)
            let objectToDelete = result[0] as! NSManagedObject
            context.delete(objectToDelete)
            print(objectToDelete)
            try context.save()
        } catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
    }
}
