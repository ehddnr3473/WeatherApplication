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
 1. Core Location을 사용해 사용자의 위치 정보를 받아옴.
 2. 위치 정보를 Query로 현재 위치의 도시 이름을 받아옴.
 3. 받아온 도시 이름을 Query로 현재 날씨 데이터와 예보 데이터를 받아옴.
 */
final class CurrentWeatherViewController: UIViewController {
    
    // MARK: - Properties
    private let apiManager = FetchData()
    private var currentCity = CurrentCity()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
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
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 40)
        
        return label
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let todayWeatherForecastCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = AppStyles.Colors.backgroundColor
        collectionView.layer.cornerRadius = AppStyles.cornerRadius
        collectionView.layer.borderWidth = AppStyles.borderWidth
        collectionView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        collectionView.register(TodayWeatherForecastCollectionViewCell.self, forCellWithReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Forecast".localized
        
        return label
    }()
    
    private let weatherForecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = AppStyles.Colors.backgroundColor
        tableView.layer.cornerRadius = AppStyles.cornerRadius
        tableView.layer.borderWidth = AppStyles.borderWidth
        tableView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        tableView.register(WeatherForecastTableViewCell.self, forCellReuseIdentifier: WeatherForecastTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "오류", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default)
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
extension CurrentWeatherViewController {
    private func setUpUI() {
        view.backgroundColor = .black
        setUpHierachy()
        setUpLayout()
    }
    
    private func setUpHierachy() {
        [weatherBackgroundImageView, currentWeatherStackView, todayWeatherForecastCollectionView, titleLabel, weatherForecastTableView, activityIndicatorView].forEach {
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
            currentWeatherStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentWeatherStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: LayoutConstants.stackViewWidthMultiplier),
            currentWeatherStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: LayoutConstants.stackViewHeightMultiplier),
            
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
        activityIndicatorView.startAnimating()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.restrictRotation = .portrait
        requestAuthorization()
        
        todayWeatherForecastCollectionView.dataSource = self
        todayWeatherForecastCollectionView.delegate = self
        
        weatherForecastTableView.dataSource = self
        weatherForecastTableView.delegate = self
    }
    
    @MainActor private func setCityName(with cityName: String) {
        currentCity.setCityName(with: cityName)
        self.cityNameLabel.text = currentCity.name
    }
    
    @MainActor private func setCurrentWeather(weather: String, temperature: Double) {
        currentCity.setCurrentWeather(weather: weather, temperature: temperature)
        
        weatherLabel.text = currentCity.weather
        
        if let temperature = currentCity.temperature {
            temperatureLabel.text = String(Int(temperature)) + AppText.celsiusString
        }
    }
    
    @MainActor private func setBackgroundImage(with imageName: String) {
        weatherBackgroundImageView.image = UIImage(named: imageName)
    }
    
    @MainActor private func reloadAndStopIndicator() {
        todayWeatherForecastCollectionView.reloadData()
        weatherForecastTableView.reloadData()
        activityIndicatorView.stopAnimating()
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
        currentCity.emptyForecast()
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
        alertWillAppear(alert, CoreLocationErrorMessage.fail)
    }
}

// MARK: - REQUEST
extension CurrentWeatherViewController {
    private func requestCurrentWeather() {
        guard let currentLocation = currentLocation else { return }
        
        guard let url: URL = apiManager.getReverseGeocodingURL(with: currentLocation) else { return }
        
        Task {
            await requestCityName(with: url)
        }
    }
    
    private func requestCityName(with url: URL) async {
        do {
            let data = try await apiManager.requestData(with: url)
            guard let cityName = DecodingManager.decode(with: data, modelType: [CityName].self) else { return }
            setCityName(with: localizationCityName(cityName))
            verifyAndRequestWeatherData(cityName[.zero].name)
        } catch {
            alertWillAppear(alert, apiManager.errorMessage(error))
        }
    }
    
    private func localizationCityName(_ cityName: [CityName]) -> String {
        if AppText.language == "kr" {
            return cityName[.zero].koreanNameOfCity.cityName ?? cityName[.zero].name
        } else {
            return cityName[.zero].name
        }
    }
    
    private func verifyAndRequestWeatherData(_ cityName: String) {
        let regex = try? NSRegularExpression(pattern: StringConstants.pattern)
        if let _ = regex?.firstMatch(in: cityName, range: NSRange(location: 0, length: cityName.count)) {
            guard let url: URL = self.apiManager.getCityWeatherURL(with: cityName) else { return }
            Task {
                await requestWeather(with: url)
                await requestWeatherForecast(with: cityName)
            }
        } else {
            let refinedCityName = refineCityName(cityName)
            guard let url: URL = self.apiManager.getCityWeatherURL(with: refinedCityName) else { return }
            Task {
                await requestWeather(with: url)
                await requestWeatherForecast(with: refinedCityName)
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
    
    private func requestWeather(with url: URL) async {
        do {
            let data = try await apiManager.requestData(with: url)
            guard let currentWeather = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
            setBackgroundImage(with: FetchImageName.setUpBackgroundImage(weather: currentWeather.weather[.zero].id))
            setCurrentWeather(weather: currentWeather.weather[.zero].description, temperature: currentWeather.main.temp)
        } catch(let error){
            alertWillAppear(alert, apiManager.errorMessage(error))
        }
    }
    
    private func requestWeatherForecast(with cityName: String) async {
        guard let url: URL = apiManager.getWeatherForecastURL(with: cityName) else { return }
        do {
            let data = try await apiManager.requestData(with: url)
            guard let forecast = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
            
            // 24시간 동안의 예보
            setUpDayForecast(with: forecast)
            
            // 내일부터 3일간의 예보
            appendForecastsTomorrow(with: forecast)
            
            reloadAndStopIndicator()
        } catch {
            alertWillAppear(alert, apiManager.errorMessage(error))
        }
    }
    
    // For 24시간 동안의 예보
    private func setUpDayForecast(with forecast: Forecast) {
        currentCity.setUpDayForecast(with: forecast)
    }
    
    // For 3일간의 예보
    private func appendForecastsTomorrow(with forecast: Forecast) {
        currentCity.appendForecastsTomorrow(with: forecast)
    }
}

// MARK: - CollectionView
extension CurrentWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayWeatherForecastCollectionViewCell.identifier, for: indexPath) as? TodayWeatherForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let forecast = currentCity.forecast else { return UICollectionViewCell() }

        let time = Date(timeIntervalSince1970: forecast.list[indexPath.row].date)
            .formatted(Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated)))
        
        cell.timeLabel.text = time
        cell.weatherImageView.image = UIImage(named: FetchImageName.setForecastImage(weather: forecast.list[indexPath.row].weather[.zero].id))?.withRenderingMode(.alwaysTemplate)
        cell.weatherLabel.text = forecast.list[indexPath.row].weather[.zero].description
        cell.temperatureLabel.text = String(Int(forecast.list[indexPath.row].main.temp)) + AppText.celsiusString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentCity.forecastIsNil {
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
        
        let day = Date(timeIntervalSince1970: currentCity.forecasts[indexPath.row].list[.zero].date).formatted(Date.FormatStyle().day(.twoDigits))
        
        cell.dayLabel.text = day
        if indexPath.row < currentCity.count {
            cell.setUpForecast(with: currentCity.forecasts[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentCity.isEmpty {
            return .zero
        } else {
            return currentCity.count
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
private enum LayoutConstants {
    static let standardGap: CGFloat = 8
    static let largeGap: CGFloat = 15
    static let stackViewWidthMultiplier: CGFloat = 0.6
    static let stackViewHeightMultiplier: CGFloat = 0.2
    static let collectionViewHeight: CGFloat = 100
    static let collectionViewWidth: CGFloat = collectionViewHeight
    static let tableViewHeight: CGFloat = collectionViewHeight * 3
}

private enum NumberConstants {
    static let numberOfItemsInSection = 8

}

private enum StringConstants {
    static let pattern = "^[A-Za-z]{0,}$"
}

private enum CoreLocationErrorMessage {
    static let denied = "애플리케이션을 실행하기 위해서는 위치 정보 제공이 필요합니다. 설정 > 열목날씨 > 위치에서 애플리케이션의 위치 사용 설정을 허용해주시기를 바랍니다."
    static let restricted = "보호자 통제와 같은 활성화 제한으로 인해 사용자가 애플리케이션의 상태를 변경할 수 없습니다."
    static let fail = "위치 설정 오류가 발생하였습니다."
}
