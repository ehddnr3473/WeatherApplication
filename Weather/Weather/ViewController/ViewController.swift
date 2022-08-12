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
    private var apiManager = FetchData()
    private let titleForWeatherForecastTableViewHeader: String = "3일간의 예보"
    private let getMethodString: String = "GET"
    private let celsiusString: String = "℃"
    private var forecast: Forecast?
    static var forecasts: [Forecast] = []
    
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D!
    private var latitude: String?
    private var longitude: String?
    
    private var dataSourcesOfTableView: [UITableViewDataSource] = []
    private var delegatesOfTableView: [UITableViewDelegate] = []
    private let weatherForecastTableViewDataSource = WeatherForecastTableViewDataSource()
    private let weatherForecastTableViewDelegate = WeatherForecastTableViewDelegate()
    
    private var dataSourcesOfCollectionView: [UICollectionViewDataSource] = []
    private var delegatesOfCollectionView: [UICollectionViewDelegate] = []
    private let todayWeatherForecastCollectionViewDataSource = TodayWeatherForecastCollectionViewDataSource()
    private let todayWeatherForecastCollectionViewDelegate = TodayWeatherForecastCollectionViewDelegate()
    
    
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
        
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        
        return label
    }()
    
    private var weatherLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private var todayWeatherForecastCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        
        collectionView.register(TodayWeatherForecastCollectionViewCell.self, forCellWithReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private var weatherForecastTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        
        tableView.register(WeatherForecastTableViewCell.self, forCellReuseIdentifier: WeatherForecastTableViewCell.identifier)
        
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

// MARK: - View
extension ViewController {
    private func setUpUI() {
        view.backgroundColor = UIColor.black
        setUpHierachy()
        setUpLayout()
    }
    
    private func setUpHierachy() {
        [weatherBackgroundImageView, currentWeatherStackView, todayWeatherForecastCollectionView,weatherForecastTableView, searchOtherCityButton].forEach {
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
            currentWeatherStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            todayWeatherForecastCollectionView.topAnchor.constraint(equalTo: currentWeatherStackView.bottomAnchor, constant: 20),
            todayWeatherForecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            todayWeatherForecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            todayWeatherForecastCollectionView.heightAnchor.constraint(equalToConstant: 150),
            
            weatherForecastTableView.topAnchor.constraint(equalTo: todayWeatherForecastCollectionView.bottomAnchor, constant: 20),
            weatherForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            weatherForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherForecastTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            searchOtherCityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchOtherCityButton.topAnchor.constraint(equalTo: weatherForecastTableView.bottomAnchor, constant: 8)
        ])
    }
    
    private func configure() {
        requestAuthorization()
        
        dataSourcesOfCollectionView = [todayWeatherForecastCollectionViewDataSource]
        todayWeatherForecastCollectionView.dataSource = dataSourcesOfCollectionView[0]
        
        delegatesOfCollectionView = [todayWeatherForecastCollectionViewDelegate]
        todayWeatherForecastCollectionView.delegate = delegatesOfCollectionView[0]
        
        dataSourcesOfTableView = [weatherForecastTableViewDataSource]
        weatherForecastTableView.dataSource = dataSourcesOfTableView[0]
        
        delegatesOfTableView = [weatherForecastTableViewDelegate]
        weatherForecastTableView.delegate = delegatesOfTableView[0]
    }
    
    @IBAction func touchUpSearchOtherCityButton(_ sender: UIButton) {
        let nextViewController = OtherCityViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func setCityName(cityName: String) {
        self.cityNameLabel.text = cityName
    }
    
    private func setCurrentWeather(weather: String, temperature: Double) {
        self.weatherLabel.text = weather
        self.temperatureLabel.text = String(Int(temperature)) + celsiusString
    }
}

// MARK: - CoreLocation
extension ViewController: CLLocationManagerDelegate {
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
}

// MARK: - REQUEST
extension ViewController {
    private func requestCurrentWeather() {
        guard let lat = latitude else { return }
        guard let lon = longitude else { return }
        
        guard let url: URL = apiManager.getReverseGeocodingURL(lat: lat, lon: lon) else { return }
        requestCityName(url: url)
    }
    
    private func requestCityName(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] (isSuccess, data) in
            if isSuccess {
                guard let self = self, let city = DecodingManager.decode(with: data, modelType: [CityName].self) else { return }
                
                DispatchQueue.main.async {
                    self.setCityName(cityName: city[0].koreanNameOfCity.cityName)
                }
                
                DispatchQueue.global().async {
                    self.requestWeatherForecast(cityName: city[0].koreanNameOfCity.ascii ?? city[0].name)
                }
                
                guard let url: URL = self.apiManager.getCityWeatherURL(cityName: city[0].koreanNameOfCity.ascii ?? city[0].name) else { return }
                self.requestWeatherDataOfCity(url: url)
            }
        })
    }
    
    private func requestWeatherDataOfCity(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] (isSuccess, data) in
            if isSuccess {
                guard let self = self, let currentWeatherOfCity = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
                
                DispatchQueue.main.async {
                    self.weatherBackgroundImageView.image = UIImage(named: FetchImageName.setUpBackgroundImage(weather: currentWeatherOfCity.weather[0].id))
                    self.setCurrentWeather(weather: currentWeatherOfCity.weather[0].description, temperature: currentWeatherOfCity.main.temp)
                }
            }
        })
    }
    
    private func requestWeatherForecast(cityName: String) {
        guard let url: URL = apiManager.getWeatherForecastURL(cityName: cityName) else { return }
        apiManager.requestData(url: url, completion: { [weak self] (isSuccess, data) in
            if isSuccess {
                guard let self = self, var todayWeatherOfCity = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
                todayWeatherOfCity.list.removeSubrange(0...2)
                self.forecast = todayWeatherOfCity
                self.todayWeatherForecastCollectionViewDataSource.forecast = self.forecast
                
                self.makeArray(forecast: todayWeatherOfCity)
                
                DispatchQueue.main.async {
                    self.todayWeatherForecastCollectionView.reloadData()
                    self.weatherForecastTableView.reloadData()
                }
            }
        })
    }
    
    private func makeArray(forecast: Forecast) {
        var forecast = forecast
        forecast.list.removeSubrange(0...8)
        ViewController.forecasts.append(forecast)
        forecast.list.removeSubrange(0...8)
        ViewController.forecasts.append(forecast)
        forecast.list.removeSubrange(0...8)
        ViewController.forecasts.append(forecast)
    }
}
