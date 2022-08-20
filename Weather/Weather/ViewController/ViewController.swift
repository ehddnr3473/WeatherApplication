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
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
        return label
    }()
    
    private var weatherLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
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
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "3일간의 예보"
        
        return label
    }()
    
    private var weatherForecastTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = AppStyles.Colors.backgroundColor
        tableView.layer.cornerRadius = AppStyles.cornerRadius
        tableView.layer.borderWidth = AppStyles.borderWidth
        tableView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
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
    
    private let alert: UIAlertController = {
        let alert: UIAlertController = UIAlertController(title: "오류", message: "", preferredStyle: UIAlertController.Style.alert)
        
        return alert
    }()
    
    private let okAction: UIAlertAction = {
        let action: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        
        return action
    }()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
        configure()
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
        [weatherBackgroundImageView, currentWeatherStackView, todayWeatherForecastCollectionView, titleLabel, weatherForecastTableView, searchOtherCityButton].forEach {
            view.addSubview($0)
        }
        
        [cityNameLabel, temperatureLabel, weatherLabel].forEach {
            currentWeatherStackView.addArrangedSubview($0)
        }
    }
    
    private func setUpLayout() {
        let safeGuideLine: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            weatherBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            currentWeatherStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeatherStackView.topAnchor.constraint(equalTo: safeGuideLine.topAnchor),
            currentWeatherStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            currentWeatherStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            todayWeatherForecastCollectionView.topAnchor.constraint(equalTo: currentWeatherStackView.bottomAnchor, constant: 20),
            todayWeatherForecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            todayWeatherForecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            todayWeatherForecastCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: todayWeatherForecastCollectionView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            weatherForecastTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            weatherForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            weatherForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherForecastTableView.heightAnchor.constraint(equalToConstant: 300),
            
            searchOtherCityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchOtherCityButton.topAnchor.constraint(equalTo: weatherForecastTableView.bottomAnchor, constant: 10)
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
    
    @IBAction func touchUpSearchOtherCityButton(_ sender: UIButton) {
        let nextViewController = OtherCityViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            currentLocation = manager.location?.coordinate
            latitude = String(currentLocation.latitude)
            longitude = String(currentLocation.longitude)
            requestCurrentWeather()
        case .authorizedWhenInUse:
            currentLocation = manager.location?.coordinate
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
extension ViewController {
    private func requestCurrentWeather() {
        guard let lat = latitude else { return }
        guard let lon = longitude else { return }
        
        guard let url: URL = apiManager.getReverseGeocodingURL(lat: lat, lon: lon) else { return }
        requestCityName(url: url)
    }
    
    private func requestCityName(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let city = DecodingManager.decode(with: data, modelType: [CityName].self) else { return }
                
                DispatchQueue.main.async {
                    self.setCityName(cityName: city[0].koreanNameOfCity.cityName)
                }
                
                DispatchQueue.global().async {
                    self.requestWeatherForecast(cityName: city[0].koreanNameOfCity.ascii ?? city[0].name)
                }
                
                guard let url: URL = self.apiManager.getCityWeatherURL(cityName: city[0].koreanNameOfCity.ascii ?? city[0].name) else { return }
                self.requestWeatherDataOfCity(url: url)
            case .failure(let error):
                switch error {
                default:
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if !self.alert.isBeingPresented {
                            self.alert.message = self.apiManager.errorHandler(error: error)
                            self.present(self.alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
    }
    
    private func requestWeatherDataOfCity(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let currentWeatherOfCity = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
                
                DispatchQueue.main.async {
                    self.weatherBackgroundImageView.image = UIImage(named: FetchImageName.setUpBackgroundImage(weather: currentWeatherOfCity.weather[0].id))
                    self.setCurrentWeather(weather: currentWeatherOfCity.weather[0].description, temperature: currentWeatherOfCity.main.temp)
                }
            case .failure(let error):
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if !self.alert.isBeingPresented {
                            self.alert.message = self.apiManager.errorHandler(error: error)
                            self.present(self.alert, animated: true, completion: nil)
                        }
                    }
            }
        })
    }
    
    private func requestWeatherForecast(cityName: String) {
        guard let url: URL = apiManager.getWeatherForecastURL(cityName: cityName) else { return }
        apiManager.requestData(url: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, var todayWeatherOfCity = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
                todayWeatherOfCity.list.removeSubrange(0...2)
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
                        self.alert.message = self.apiManager.errorHandler(error: error)
                        self.present(self.alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    private func appendDayList(time: String) {
        var result: String
        var day: Int
        let startIndex = time.index(time.startIndex, offsetBy: 8)
        let endIndex = time.index(time.endIndex, offsetBy: -10)
        day = Int(String(time[startIndex...endIndex]))!
        
        result = String(day) + AppText.day
        dayList.append(result)
    }
    
    private func setUpToday(time: String) {
        var day: String
        let startIndex = time.index(time.startIndex, offsetBy: 8)
        let endIndex = time.index(time.endIndex, offsetBy: -10)
        day = String(time[startIndex...endIndex])
        
        today = day
    }
    
    private func getTomorrowString(time: String) -> String {
        var day: String
        let startIndex = time.index(time.startIndex, offsetBy: 8)
        let endIndex = time.index(time.endIndex, offsetBy: -10)
        day = String(time[startIndex...endIndex])
        
        return day
    }
    
    private func setUpTomorrow(forecast: Forecast) {
        for i in 0..<forecast.list.count {
            if getTomorrowString(time: forecast.list[i].time) != today {
                startOfTomorrowIndex = i
                break
            }
        }
    }
    
    private func makeArray(forecast: Forecast) {
        var forecast = forecast
        setUpToday(time: forecast.list[0].time)
        setUpTomorrow(forecast: forecast)
        guard let startOfTomorrowIndex = startOfTomorrowIndex else { return }
        forecast.list.removeSubrange(0..<startOfTomorrowIndex)

        forecasts.append(forecast)
        appendDayList(time: forecast.list[0].time)
        forecast.list.removeSubrange(0...7)
        forecasts.append(forecast)
        appendDayList(time: forecast.list[0].time)
        forecast.list.removeSubrange(0...7)
        forecasts.append(forecast)
        appendDayList(time: forecast.list[0].time)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastTableViewCell.identifier, for: indexPath) as? WeatherForecastTableViewCell else { return UITableViewCell() }
        
        cell.dayLabel.text = dayList[indexPath.row]
        cell.prepare(forecast: forecasts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forecasts.isEmpty {
            return 0
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = AppStyles.borderWidth
        cell.layer.borderColor = AppStyles.Colors.mainColor.cgColor
    }
}
