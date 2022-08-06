//
//  ViewController.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/02.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private var weather = Weather()
    private var apiManager = FetchData()
    private let titleForHeader: String = "일주일 간의 날씨"
    private let getMethodString: String = "GET"
    private let celsiusString: String = "℃"
    
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D!
    private var latitude: String?
    private var longitude: String?
    
    
    private var weatherBackgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var currentWeatherStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private var cityNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        
        return label
    }()
    
    private var weatherLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
//    private var extremeTemperatureStackView: UIStackView = {
//        let stackView: UIStackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 8
//
//        return stackView
//    }()
//
//    private var highestTemperatureLabel: UILabel = {
//        let label: UILabel = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        label.textColor = UIColor.white
//        label.textAlignment = NSTextAlignment.center
//
//        return label
//    }()
//
//    private var lowestTemperatureLabel: UILabel = {
//        let label: UILabel = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        label.textColor = UIColor.white
//        label.textAlignment = NSTextAlignment.center
//
//        return label
//    }()
    
    private var weekLongWeatherTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        
        tableView.register(WeekLongWeatherTableViewCell.self, forCellReuseIdentifier: WeekLongWeatherTableViewCell.identifier)
        
        return tableView
    }()
    
    private lazy var searchOtherCityButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(touchUpSearchOtherCityButton(_:)), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpUI()
        configure()
        requestCurrentWeather()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    private func setUpUI() {
        view.backgroundColor = UIColor.white
        setUpHierachy()
        setUpLayout()
    }
    
    private func setUpHierachy() {
        [weatherBackgroundImageView, currentWeatherStackView, weekLongWeatherTableView, searchOtherCityButton].forEach {
            view.addSubview($0)
        }
        
        [cityNameLabel, temperatureLabel, weatherLabel].forEach {
            currentWeatherStackView.addArrangedSubview($0)
        }
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            weatherBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            currentWeatherStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeatherStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            currentWeatherStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            currentWeatherStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            weekLongWeatherTableView.topAnchor.constraint(equalTo: currentWeatherStackView.bottomAnchor, constant: 20),
            weekLongWeatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            weekLongWeatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weekLongWeatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
//            searchOtherCityButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
//            searchOtherCityButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            searchOtherCityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchOtherCityButton.topAnchor.constraint(equalTo: weekLongWeatherTableView.bottomAnchor, constant: 8)
        ])
    }
    
    private func configure() {
        requestAuthorization()
        weekLongWeatherTableView.dataSource = self
        weekLongWeatherTableView.delegate = self
    }
    
    @IBAction func touchUpSearchOtherCityButton(_ sender: UIButton) {
        let nextViewController = OtherCityViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekLongWeatherTableViewCell.identifier, for: indexPath) as? WeekLongWeatherTableViewCell else { return UITableViewCell() }
        cell.dayLabel.text = "임시"
        cell.dayLabel.textColor = UIColor.white
        cell.dayLabel.font = .boldSystemFont(ofSize: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    // MARK: - CoreLocation
    private func requestAuthorization() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
            locationManagerDidChangeAuthorization(locationManager!)
        } else {
            // 사용자의 위치가 바뀌고있는지 확인하는 메서드
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            latitude = String(currentLocation.latitude)
            longitude = String(currentLocation.longitude)
        }
    }
    
    // MARK: - REQUEST
    private func requestCurrentWeather() {
        guard let lat = latitude else { fatalError() }
        guard let lon = longitude else { fatalError() }
        
        guard let url: URL = apiManager.getCurrentWeatherURL(lat: lat, lon: lon) else { return }
        requestData(url: url)
    }
    
    private func requestData(url: URL) {
        apiManager.requestData(url: url, completion: { (isSuccess, data) in
            if isSuccess {
                guard let currentWeather = DecodingManager.decode(with: data, modelType: Current.self) else { return }
                self.setUpBackgroundImage(weather: currentWeather.weather[0].id)
                self.setCurrentWeather(weather: currentWeather.weather[0].description, cityName: currentWeather.name, temperature: currentWeather.main.temp)
            }
        })
    }
    
    private func setUpBackgroundImage(weather: Int) {
        switch weather {
        case 200...232:
            weatherBackgroundImageView.image = UIImage(named: self.weather.thunder)
        case 300...531:
            weatherBackgroundImageView.image = UIImage(named: self.weather.rainy)
        case 600...622:
            weatherBackgroundImageView.image = UIImage(named: self.weather.snow)
        case 701...721:
            weatherBackgroundImageView.image = UIImage(named: self.weather.mist)
        case 731:
            weatherBackgroundImageView.image = UIImage(named: self.weather.dust)
        case 741:
            weatherBackgroundImageView.image = UIImage(named: self.weather.mist)
        case 751...761:
            weatherBackgroundImageView.image = UIImage(named: self.weather.dust)
        case 762:
            weatherBackgroundImageView.image = UIImage(named: self.weather.volcanicAsh)
        case 771...781:
            weatherBackgroundImageView.image = UIImage(named: self.weather.squalls)
        case 800:
            weatherBackgroundImageView.image = UIImage(named: self.weather.clear)
        case 801...804:
            weatherBackgroundImageView.image = UIImage(named: self.weather.cloudy)
        case 900...902:
            weatherBackgroundImageView.image = UIImage(named: self.weather.squalls)
        case 903:
            weatherBackgroundImageView.image = UIImage(named: self.weather.cold)
        case 904:
            weatherBackgroundImageView.image = UIImage(named: self.weather.hot)
        case 905:
            weatherBackgroundImageView.image = UIImage(named: self.weather.windy)
        case 906:
            weatherBackgroundImageView.image = UIImage(named: self.weather.hail)
        case 951...956:
            weatherBackgroundImageView.image = UIImage(named: self.weather.clear)
        case 957...962:
            weatherBackgroundImageView.image = UIImage(named: self.weather.squalls)
        default:
            weatherBackgroundImageView.image = UIImage(named: self.weather.clear)
        }
    }
    
    private func setCurrentWeather(weather: String, cityName: String, temperature: Double) {
        self.weatherLabel.text = weather
        self.cityNameLabel.text = cityName
        self.temperatureLabel.text = String(Int(temperature)) + celsiusString
    }
}
