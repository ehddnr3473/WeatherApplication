//
//  ViewController.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/02.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewController: UIViewController {
    
    // MARK: - Properties
    private var apiManager = FetchData()
    private var forecast: Forecast?
    private var forecasts: [Forecast] = []
    
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D!
    private var latitude: String?
    private var longitude: String?
    
    var dayList: [String] = []
    private var today: String?
    private var startOfTomorrowIndex: Int?
    
    private var weatherBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var currentWeatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private var cityNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
        return label
    }()
    
    private var weatherLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private var todayWeatherForecastCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = AppStyles.Colors.backgroundColor
        collectionView.layer.cornerRadius = AppStyles.cornerRadius
        collectionView.layer.borderWidth = AppStyles.borderWidth
        collectionView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        collectionView.register(TodayWeatherForecastCollectionViewCell.self, forCellWithReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "3일간의 예보"
        
        return label
    }()
    
    private var weatherForecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = AppStyles.Colors.backgroundColor
        tableView.layer.cornerRadius = AppStyles.cornerRadius
        tableView.layer.borderWidth = AppStyles.borderWidth
        tableView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        tableView.register(WeatherForecastTableViewCell.self, forCellReuseIdentifier: WeatherForecastTableViewCell.identifier)
        return tableView
    }()
    
    private let alert: UIAlertController = {
        let alert = UIAlertController(title: "오류", message: "", preferredStyle: UIAlertController.Style.alert)
        
        return alert
    }()
    
    private let okAction: UIAlertAction = {
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        
        return action
    }()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        configure()
    }
}

// MARK: - View
extension CurrentWeatherViewController {
    private func setUpUI() {
        view.backgroundColor = UIColor.black
        setUpHierachy()
        setUpLayout()
    }
    
    private func setUpHierachy() {
        [weatherBackgroundImageView, currentWeatherStackView, todayWeatherForecastCollectionView, titleLabel, weatherForecastTableView].forEach {
            view.addSubview($0)
        }
        
        [cityNameLabel, temperatureLabel, weatherLabel].forEach {
            currentWeatherStackView.addArrangedSubview($0)
        }
    }
    
    private func setUpLayout() {
        let safeGuideLine = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            weatherBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            currentWeatherStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeatherStackView.topAnchor.constraint(equalTo: safeGuideLine.topAnchor),
            currentWeatherStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: LayoutConstants.stackViewWidth),
            currentWeatherStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: LayoutConstants.stackViewHeight),
            
            todayWeatherForecastCollectionView.topAnchor.constraint(equalTo: currentWeatherStackView.bottomAnchor, constant: LayoutConstants.standardGap),
            todayWeatherForecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.standardGap),
            todayWeatherForecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.standardGap),
            todayWeatherForecastCollectionView.heightAnchor.constraint(equalToConstant: LayoutConstants.collectionViewHeight),
            
            titleLabel.topAnchor.constraint(equalTo: todayWeatherForecastCollectionView.bottomAnchor, constant: LayoutConstants.standardGap),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.largeGap),
            
            weatherForecastTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.standardGap),
            weatherForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.standardGap),
            weatherForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.standardGap),
            weatherForecastTableView.heightAnchor.constraint(equalToConstant: LayoutConstants.tableViewHeight)
        ])
    }
    
    private func configure() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.restrictRotation = .portrait
        requestAuthorization()
        
        todayWeatherForecastCollectionView.dataSource = self
        todayWeatherForecastCollectionView.delegate = self
        
        weatherForecastTableView.dataSource = self
        weatherForecastTableView.delegate = self
        
        alert.addAction(okAction)
    }
    
    private func setCityName(cityName: String) {
        self.cityNameLabel.text = cityName
    }
    
    private func setCurrentWeather(weather: String, temperature: Double) {
        self.weatherLabel.text = weather
        self.temperatureLabel.text = String(Int(temperature)) + AppText.celsiusString
    }
}

// MARK: - CoreLocation
extension CurrentWeatherViewController: CLLocationManagerDelegate {
    private func requestAuthorization() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestAlwaysAuthorization()
            locationManager!.delegate = self
            locationManagerDidChangeAuthorization(locationManager!)
        } else {
            // 사용자의 위치가 바뀌고있는지 확인하는 메서드
            locationManager!.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            guard let currentLocation = manager.location?.coordinate else { return }
            latitude = String(currentLocation.latitude)
            longitude = String(currentLocation.longitude)
            requestCurrentWeather()
        case .authorizedWhenInUse:
            guard let currentLocation = manager.location?.coordinate else { return }
            latitude = String(currentLocation.latitude)
            longitude = String(currentLocation.longitude)
            requestCurrentWeather()
        case .denied:
            alert.message = AppText.AlertMessage.denied
            present(alert, animated: true, completion: nil)
            requestAuthorization()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            alert.message = AppText.AlertMessage.restricted
            present(alert, animated: true, completion: nil)
            requestAuthorization()
        @unknown default:
            alert.message = AppText.AlertMessage.undefined
            present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        alert.message = AppText.AlertMessage.fail
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - REQUEST
extension CurrentWeatherViewController {
    private func requestCurrentWeather() {
        guard let lat = latitude else { return }
        guard let lon = longitude else { return }
        
        guard let url: URL = apiManager.getReverseGeocodingURL(lat: lat, lon: lon) else { return }
        requestCityName(url: url)
    }
    
    private func requestCityName(url: URL) {
        apiManager.requestData(with: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let city = DecodingManager.decode(with: data, modelType: [CityName].self) else { return }
                
                DispatchQueue.main.async {
                    self.setCityName(cityName: city[.zero].koreanNameOfCity.cityName ?? city[.zero].name)
                }
                
                self.verifyAndRequestWeatherData(city[.zero].name)
                
            case .failure(let error):
                switch error {
                default:
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if !self.alert.isBeingPresented {
                            self.alert.message = self.apiManager.errorHandler(error)
                            self.present(self.alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
    }
    
    private func verifyAndRequestWeatherData(_ cityName: String) {
        let pattern = "^[A-Za-z]{0,}$"
        
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: cityName, range: NSRange(location: 0, length: cityName.count)) {
            guard let url: URL = self.apiManager.getCityWeatherURL(with: cityName) else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                self.requestWeatherDataOfCity(url)
                self.requestWeatherForecast(cityName)
            }
        } else {
            let refinedCityName = refineCityName(cityName)
            guard let url: URL = self.apiManager.getCityWeatherURL(with: refinedCityName) else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                self.requestWeatherDataOfCity(url)
                self.requestWeatherForecast(refinedCityName)
            }
        }
    }
    
    private func refineCityName(_ cityName: String) -> String {
        var cityName = cityName
        let startIndex = cityName.startIndex
        
        for index in cityName.indices {
            if cityName[index] == "-" || cityName[index] == "," {
                cityName = String(cityName[startIndex..<index])
                break
            }
        }
        return cityName
    }
    
    private func requestWeatherDataOfCity(_ url: URL) {
        apiManager.requestData(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let currentWeatherOfCity = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
                
                DispatchQueue.main.async {
                    self.weatherBackgroundImageView.image = UIImage(named: FetchImageName.setUpBackgroundImage(weather: currentWeatherOfCity.weather[.zero].id))
                    self.setCurrentWeather(weather: currentWeatherOfCity.weather[.zero].description, temperature: currentWeatherOfCity.main.temp)
                }
            case .failure(let error):
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if !self.alert.isBeingPresented {
                            self.alert.message = self.apiManager.errorHandler(error)
                            self.present(self.alert, animated: true, completion: nil)
                        }
                    }
            }
        }
    }
    
    private func requestWeatherForecast(_ cityName: String) {
        guard let url: URL = apiManager.getWeatherForecastURL(with: cityName) else { return }
        apiManager.requestData(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, var todayWeatherOfCity = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
                todayWeatherOfCity.list.removeSubrange(NumberConstants.fromZeroToTwo)
                self.forecast = todayWeatherOfCity
                self.makeArray(forecast: todayWeatherOfCity)
                DispatchQueue.main.async {
                    self.todayWeatherForecastCollectionView.reloadData()
                    self.weatherForecastTableView.reloadData()
                }
            case .failure(let error):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !self.alert.isBeingPresented {
                        self.alert.message = self.apiManager.errorHandler(error)
                        self.present(self.alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func appendDayList(time: String) {
        var result: String
        let startIndex = time.index(time.startIndex, offsetBy: NumberConstants.startOffset)
        let endIndex = time.index(time.endIndex, offsetBy: -NumberConstants.endOffset)
        guard let day = Int(String(time[startIndex...endIndex])) else { return }
        
        result = String(day) + AppText.day
        dayList.append(result)
    }
    
    private func setUpToday(time: String) {
        var day: String
        let startIndex = time.index(time.startIndex, offsetBy: NumberConstants.startOffset)
        let endIndex = time.index(time.endIndex, offsetBy: -NumberConstants.endOffset)
        day = String(time[startIndex...endIndex])
        
        today = day
    }
    
    private func getTomorrowString(time: String) -> String {
        var day: String
        let startIndex = time.index(time.startIndex, offsetBy: NumberConstants.startOffset)
        let endIndex = time.index(time.endIndex, offsetBy: -NumberConstants.endOffset)
        day = String(time[startIndex...endIndex])
        
        return day
    }
    
    private func setUpTomorrow(forecast: Forecast) {
        for index in forecast.list.indices {
            if getTomorrowString(time: forecast.list[index].time) != today {
                startOfTomorrowIndex = index
                break
            }
        }
    }
    
    private func makeArray(forecast: Forecast) {
        var forecast = forecast
        setUpToday(time: forecast.list[.zero].time)
        setUpTomorrow(forecast: forecast)
        guard let startOfTomorrowIndex = startOfTomorrowIndex else { return }
        forecast.list.removeSubrange(.zero..<startOfTomorrowIndex)

        forecasts.append(forecast)
        appendDayList(time: forecast.list[.zero].time)
        forecast.list.removeSubrange(NumberConstants.fromZeroToSeven)
        forecasts.append(forecast)
        appendDayList(time: forecast.list[.zero].time)
        forecast.list.removeSubrange(NumberConstants.fromZeroToSeven)
        forecasts.append(forecast)
        appendDayList(time: forecast.list[.zero].time)
    }
}

extension CurrentWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let forecast = forecast else { return UICollectionViewCell() }

        cell.timeLabel.text = AppText.getTimeText(time: forecast.list[indexPath.row].time)
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: forecast.list[indexPath.row].weather[.zero].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = forecast.list[indexPath.row].weather[.zero].description
        cell.temperatureLabel.text = String(Int(forecast.list[indexPath.row].main.temp)) + AppText.celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecast == nil {
            return .zero
        } else {
            return NumberConstants.numberOfItemsInSection
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LayoutConstants.collectionViewWidth, height: LayoutConstants.collectionViewHeight)
    }
}

extension CurrentWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCell.identifier, for: indexPath) as? WeatherForecastTableViewCell else { return UITableViewCell() }
        
        cell.dayLabel.text = dayList[indexPath.row]
        cell.prepare(with: forecasts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forecasts.isEmpty {
            return .zero
        } else {
            return NumberConstants.numberOfRowsInSection
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConstants.collectionViewHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = AppStyles.borderWidth
        cell.layer.borderColor = AppStyles.Colors.mainColor.cgColor
    }
}

// MARK: - Magic Number
private struct LayoutConstants {
    static let standardGap: CGFloat = 8
    static let largeGap: CGFloat = 15
    static let stackViewWidth: CGFloat = 0.6
    static let stackViewHeight: CGFloat = 0.2
    static let collectionViewHeight: CGFloat = 100
    static let collectionViewWidth: CGFloat = collectionViewHeight
    static let tableViewHeight: CGFloat = collectionViewHeight * 3
}

private struct NumberConstants {
    static let fromZeroToTwo = 0...2
    static let fromZeroToSeven = 0...7
    static let numberOfItemsInSection = 8
    static let numberOfRowsInSection = 3
    static let startOffset = 8
    static let endOffset = 10
}
