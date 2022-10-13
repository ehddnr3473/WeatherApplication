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
    
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
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
        label.font = .boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 40)
        
        return label
    }()
    
    private var weatherLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        
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
        
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
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
        view.backgroundColor = .black
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
    
    private func setCityName(with cityName: String) {
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
        requestCurrentWeather()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        forecast = nil
        forecasts.removeAll()
        switch manager.authorizationStatus {
        case .authorizedAlways:
            manager.requestLocation()
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .denied:
            if !alert.isBeingPresented {
                alert.message = AppText.AlertMessage.denied
                present(alert, animated: true, completion: nil)
            }
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            if !alert.isBeingPresented {
                alert.message = AppText.AlertMessage.restricted
                present(alert, animated: true, completion: nil)
            }
        @unknown default:
            if !alert.isBeingPresented {
                alert.message = AppText.AlertMessage.fail
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        if !alert.isBeingPresented {
            alert.message = AppText.AlertMessage.fail
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - REQUEST
extension CurrentWeatherViewController {
    private func requestCurrentWeather() {
        guard let currentLocation = currentLocation else { return }
        
        guard let url: URL = apiManager.getReverseGeocodingURL(with: currentLocation) else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.requestCityName(with: url)
        }
    }
    
    private func requestCityName(with url: URL) {
        apiManager.requestData(with: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let city = DecodingManager.decode(with: data, modelType: [CityName].self) else { return }
                
                DispatchQueue.main.async {
                    self.setCityName(with: city[.zero].koreanNameOfCity.cityName ?? city[.zero].name)
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
        let regex = try? NSRegularExpression(pattern: AppText.pattern)
        if let _ = regex?.firstMatch(in: cityName, range: NSRange(location: 0, length: cityName.count)) {
            guard let url: URL = self.apiManager.getCityWeatherURL(with: cityName) else { return }
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.requestWeatherDataOfCity(with: url)
                self?.requestWeatherForecast(with: cityName)
            }
        } else {
            let refinedCityName = refineCityName(cityName)
            guard let url: URL = self.apiManager.getCityWeatherURL(with: refinedCityName) else { return }
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.requestWeatherDataOfCity(with: url)
                self?.requestWeatherForecast(with: refinedCityName)
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
    
    private func requestWeatherDataOfCity(with url: URL) {
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
    
    private func requestWeatherForecast(with cityName: String) {
        guard let url: URL = apiManager.getWeatherForecastURL(with: cityName) else { return }
        apiManager.requestData(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let forecastWeatherOfCity = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
            
                // 24시간 동안의 예보
                self.forecast = self.setUpDayForecast(with: forecastWeatherOfCity)
                
                // 내일부터 3일간의 예보
                self.appendForecastsTomorrow(with: forecastWeatherOfCity)
                
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
    
    // For 24시간 동안의 예보
    private func setUpDayForecast(with forecast: Forecast) -> Forecast {
        var forecast = forecast
        if forecast.list.count > NumberConstants.numberOfItemsInSection {
            forecast.list.removeSubrange(NumberConstants.fromEightToEnd)
        }
        
        return forecast
    }
    
    // For 3일 간의 예보
    private func appendForecastsTomorrow(with forecast: Forecast) {
        var forecast = forecast
        for index in forecast.list.indices {
            if compare(to: forecast.list[index].date) {
                forecast.list.removeSubrange(.zero..<index)
                var copiedForecast = forecast
                if copiedForecast.list.count > NumberConstants.numberOfItemsInSection,
                        forecast.list.count >= NumberConstants.numberOfItemsInSection {
                    
                    copiedForecast.list.removeSubrange(NumberConstants.fromEightToEnd)
                    forecast.list.removeSubrange(NumberConstants.fromZeroToSeven)
                    
                    forecasts.append(copiedForecast)
                    appendForecastsDaysAfterTomorrow(with: forecast)
                }
                break
            }
        }
    }
    
    private func appendForecastsDaysAfterTomorrow(with forecast: Forecast) {
        var dayAfterTomorrowForecast = forecast
        if dayAfterTomorrowForecast.list.count > NumberConstants.numberOfItemsInSection {
            dayAfterTomorrowForecast.list.removeSubrange(NumberConstants.fromEightToEnd)
            forecasts.append(dayAfterTomorrowForecast)
        }
        
        var twoDaysAfterTomorrowForecast = forecast
        if twoDaysAfterTomorrowForecast.list.count >= NumberConstants.numberOfItemsInSection {
            twoDaysAfterTomorrowForecast.list.removeSubrange(NumberConstants.fromZeroToSeven)
            if twoDaysAfterTomorrowForecast.list.count > NumberConstants.numberOfItemsInSection {
                twoDaysAfterTomorrowForecast.list.removeSubrange(NumberConstants.fromEightToEnd)
                forecasts.append(twoDaysAfterTomorrowForecast)
            }
        }
    }
    
    private func compare(to date: TimeInterval) -> Bool {
        let day = Date()
        let nextDay = Date(timeIntervalSince1970: date)
        
        if dayToString(from: day) == dayToString(from: nextDay) {
            return false
        } else {
            return true
        }
    }
    
    private func dayToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = AppText.dateFormat
        
        return dateFormatter.string(from: date)
    }
}

extension CurrentWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let forecast = forecast else { return UICollectionViewCell() }

        let time = Date(timeIntervalSince1970: forecast.list[indexPath.row].date)
            .formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)))
        
        cell.timeLabel.text = time
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
        CGSize(width: LayoutConstants.collectionViewWidth, height: LayoutConstants.collectionViewHeight)
    }
}

extension CurrentWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCell.identifier, for: indexPath) as? WeatherForecastTableViewCell else { return UITableViewCell() }
        
        let day = Date(timeIntervalSince1970: forecasts[indexPath.row].list[.zero].date).formatted(Date.FormatStyle().day(.twoDigits))
        
        cell.dayLabel.text = day
        if indexPath.row < forecasts.count {
            cell.setUpForecast(with: forecasts[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forecasts.isEmpty {
            return .zero
        } else {
            return forecasts.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        LayoutConstants.collectionViewHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
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
    static let numberOfItemsInSection = 8
    static let fromZeroToTwo = 0...2
    static let fromZeroToSeven = 0...7
    static let fromEightToEnd = 8...
    static let oneDay: Double = 86400
    
}
