//
//  ViewController.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/02.
//

import UIKit
import CoreLocation

/**
 현재 위치한 도시의 날씨
 1. CoreLocation을 사용해 사용자의 위치 정보를 받아옴.
 2. 위치 정보를 query로 현재 위치의 도시 이름을 받아옴.
 3. 받아온 도시 이름을 query로 현재 날씨 데이터와 예보 데이터를 받아옴.
 */
final class CurrentWeatherViewController: UIViewController, WeatherControllable, LocationService {
    typealias Model = CurrentCity
    
    // MARK: - Properties
    var model = Model()
    let weatherNetworkService = WeatherNetworkService()
    
    let locationManager = CLLocationManager()
    
    private let weatherBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let currentWeatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutConstants.offset
        
        return stackView
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = AppStyles.Colors.mainColor
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: LayoutConstants.mediumFontSize)
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = AppStyles.Colors.mainColor
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: LayoutConstants.largeFontSize)
        
        return label
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = AppStyles.Colors.mainColor
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: LayoutConstants.smallFontSize)
        
        return label
    }()
    
    private let todayWeatherForecastCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: .zero,
                                        left: LayoutConstants.collectionViewSideInset,
                                        bottom: .zero,
                                        right: LayoutConstants.collectionViewSideInset)
        
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = AppStyles.Colors.backgroundColor
        collectionView.layer.cornerRadius = AppStyles.cornerRadius
        collectionView.layer.borderWidth = AppStyles.borderWidth
        collectionView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        collectionView.register(ForecastCollectionViewCell.self,
                                forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = AppStyles.Colors.mainColor
        label.font = .boldSystemFont(ofSize: LayoutConstants.smallFontSize)
        label.text = LocalizedText.forecast
        
        return label
    }()
    
    private let weatherForecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = AppStyles.Colors.backgroundColor
        tableView.layer.cornerRadius = AppStyles.cornerRadius
        tableView.layer.borderWidth = AppStyles.borderWidth
        tableView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        tableView.isScrollEnabled = false
        
        tableView.register(WeatherForecastTableViewCell.self, forCellReuseIdentifier: WeatherForecastTableViewCell.identifier)
        return tableView
    }()
    
    lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: LocalizedText.alertTitle, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: LocalizedText.actionTitle, style: .default)
        alert.addAction(action)
        
        return alert
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
           
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .white
           
        return activityIndicatorView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.center = currentWeatherStackView.center
    }
}

// MARK: - View
private extension CurrentWeatherViewController {
    func setUpUI() {
        view.backgroundColor = .black
        setUpHierarchy()
        setUpLayout()
    }
    
    func setUpHierarchy() {
        [weatherBackgroundImageView, currentWeatherStackView, todayWeatherForecastCollectionView, titleLabel, weatherForecastTableView, activityIndicatorView].forEach {
            view.addSubview($0)
        }
        
        [cityNameLabel, temperatureLabel, weatherLabel].forEach {
            currentWeatherStackView.addArrangedSubview($0)
        }
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            weatherBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            currentWeatherStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeatherStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentWeatherStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: LayoutConstants.stackViewWidthMultiplier),
            currentWeatherStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: LayoutConstants.stackViewHeightMultiplier),
            
            todayWeatherForecastCollectionView.topAnchor.constraint(equalTo: currentWeatherStackView.bottomAnchor, constant: LayoutConstants.offset),
            todayWeatherForecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.offset),
            todayWeatherForecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.offset),
            todayWeatherForecastCollectionView.heightAnchor.constraint(equalToConstant: LayoutConstants.collectionViewHeight),
            
            titleLabel.topAnchor.constraint(equalTo: todayWeatherForecastCollectionView.bottomAnchor, constant: LayoutConstants.offset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.largeOffset),
            
            weatherForecastTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.offset),
            weatherForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.offset),
            weatherForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.offset),
            weatherForecastTableView.heightAnchor.constraint(equalToConstant: LayoutConstants.tableViewHeight)
        ])
    }
    
    func configure() {
        activityIndicatorView.startAnimating()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.restrictRotation = .portrait
        
        locationManager.delegate = self
        requestAuthorization()
        
        todayWeatherForecastCollectionView.dataSource = self
        todayWeatherForecastCollectionView.delegate = self

        weatherForecastTableView.dataSource = self
        weatherForecastTableView.delegate = self
    }
    
    @MainActor func setCityName(with cityName: String) {
        model.setCityName(with: cityName)
        cityNameLabel.text = model.name
    }
    
    @MainActor func setCurrentWeather(weather: String, temperature: Double) {
        model.setCurrentWeather(weather: weather, temperature: temperature)
        weatherLabel.text = model.weather
        if let temperature = model.temperature {
            temperatureLabel.text = String(Int(temperature)) + AppText.celsiusString
        }
    }
    
    @MainActor func setBackgroundImage(with imageName: String) {
        weatherBackgroundImageView.image = UIImage(named: imageName)
    }
    
    @MainActor func reload() {
        todayWeatherForecastCollectionView.reloadData()
        weatherForecastTableView.reloadData()
    }
}

// MARK: - CoreLocation
extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last?.coordinate else { return }
        guard let url = weatherNetworkService.getReverseGeocodingURL(with: currentLocation) else { return }
        
        Task {
            guard let cityName = await requestCityName(with: url) else { return }
            
            if (isPureCityName(cityName)) {
                requestAllWeatherData(cityName)
            } else {
                let refinedCityName = refineCityName(cityName)
                requestAllWeatherData(refinedCityName)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        model.clear()
        switch manager.authorizationStatus {
        case .authorizedAlways:
            manager.requestLocation()
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .denied:
            alertWillAppear(alert, CoreLocationErrorMessage.denied)
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            alertWillAppear(alert, CoreLocationErrorMessage.denied)
        @unknown default:
            alertWillAppear(alert, CoreLocationErrorMessage.denied)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        alertWillAppear(alert, CoreLocationErrorMessage.failed)
    }
}

// MARK: - NetworkTask
private extension CurrentWeatherViewController {
    func requestCityName(with url: URL) async -> String? {
        do {
            let data = try await weatherNetworkService.requestData(with: url)
            guard let cityName = Decoder.decode(with: data, modelType: [CityName].self) else { return nil }
            setCityName(with: localizationCityName(cityName))
            return cityName[.zero].name
        } catch {
            alertWillAppear(alert, weatherNetworkService.errorMessage(error))
            return nil
        }
    }
    
    func localizationCityName(_ cityName: [CityName]) -> String {
        if AppText.language == AppText.korea {
            return cityName[.zero].koreanNameOfCity.cityName ?? cityName[.zero].name
        } else {
            return cityName[.zero].name
        }
    }
    
    func isPureCityName(_ cityName: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: StringConstants.pattern)
        if (regex?.firstMatch(in: cityName, range: NSRange(location: 0, length: cityName.count)) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func requestAllWeatherData(_ cityName: String) {
        guard let url = weatherNetworkService.getCurrentWeatherURL(with: cityName) else { return }
        
        Task {
            guard let currentWeather = await requestWeather(with: url) else { return }
            await requestWeatherForecast(with: cityName)
            
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.setBackgroundImage(with: BackgroundImageNameProvider.get(weather: currentWeather.weather[.zero].id))
                self.setCurrentWeather(weather: currentWeather.weather[.zero].description, temperature: currentWeather.main.temp)
                self.reload()
            }
        }
    }
    
    func refineCityName(_ cityName: String) -> String {
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
    
    func requestWeather(with url: URL) async -> WeatherOfCity? {
        do {
            let data = try await weatherNetworkService.requestData(with: url)
            return Decoder.decode(with: data, modelType: WeatherOfCity.self)
        } catch(let error){
            alertWillAppear(alert, weatherNetworkService.errorMessage(error))
            return nil
        }
    }
    
    func requestWeatherForecast(with cityName: String) async {
        guard let url = weatherNetworkService.getForecastURL(with: cityName) else { return }
        do {
            let data = try await weatherNetworkService.requestData(with: url)
            guard let forecast = Decoder.decode(with: data, modelType: Forecast.self) else { return }
            
            // 24시간 동안의 예보
            model.setUpDayForecast(with: forecast)
            // 내일부터 3일간의 예보
            model.appendForecast(with: forecast)
        } catch {
            alertWillAppear(alert, weatherNetworkService.errorMessage(error))
        }
    }
}

// MARK: - CollectionView
extension CurrentWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifier, for: indexPath) as? ForecastCollectionViewCell, let forecast = model.forecast else { return UICollectionViewCell() }

        let time = Date(timeIntervalSince1970: forecast.list[indexPath.row].date)
            .formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)))
        
        cell.timeLabel.text = time
        cell.weatherImageView.image = UIImage(named: ForecastImageNameProvider.get(weather: forecast.list[indexPath.row].weather[.zero].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = forecast.list[indexPath.row].weather[.zero].description
        cell.temperatureLabel.text = String(Int(forecast.list[indexPath.row].main.temp)) + AppText.celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model.forecast == nil {
            return .zero
        } else {
            return NumberConstants.numberOfItemsInSection
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: LayoutConstants.collectionViewWidth, height: LayoutConstants.collectionViewHeight)
    }
}

// MARK: - TableView
extension CurrentWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCell.identifier, for: indexPath) as? WeatherForecastTableViewCell else { return UITableViewCell() }
        
        let day = Date(timeIntervalSince1970: self.model.forecasts[indexPath.row].list[.zero].date).formatted(Date.FormatStyle().day(.twoDigits))
        cell.dayLabel.text = day
        cell.setUpForecast(with: self.model.forecasts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.forecasts.isEmpty {
            return .zero
        } else {
            return model.forecasts.count
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

// MARK: - Magic String & Number
private enum StringConstants {
    static let pattern = "^[A-Za-z]{0,}$"
}

private enum CoreLocationErrorMessage {
    static let denied = "Denied".localized
    static let restricted = "Restricted".localized
    static let failed = "Falied".localized
}

private enum LocalizedText {
    static let forecast = "Forecast".localized
    static let alertTitle = "AlertTitle".localized
    static let actionTitle = "ActionTitle".localized
}

private enum LayoutConstants {
    static let offset: CGFloat = 8
    static let largeOffset: CGFloat = 15
    static let stackViewWidthMultiplier: CGFloat = 0.6
    static let stackViewHeightMultiplier: CGFloat = 0.2
    static let collectionViewHeight: CGFloat = 100
    static let collectionViewWidth: CGFloat = collectionViewHeight
    static let tableViewHeight: CGFloat = collectionViewHeight * 3
    static let largeFontSize: CGFloat = 40
    static let mediumFontSize: CGFloat = 30
    static let smallFontSize: CGFloat = 20
    static let collectionViewSideInset: CGFloat = 20
}

private enum NumberConstants {
    static let numberOfItemsInSection = 8
}
