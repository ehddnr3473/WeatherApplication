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
    private let titleForHeader: String = "일주일 간의 날씨"
    private let getMethodString: String = "GET"
    private let baseURL: String = "https://api.openweathermap.org/data/2.5/weather?"
    private let appid = Bundle.main.apiKey
    
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D!
    private var latitude: String?
    private var longitude: String?
    
    private lazy var weatherBackgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var currentWeatherStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    private lazy var weatherLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    private lazy var extremeTemperatureStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var highestTemperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "최고: "
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    private lazy var lowestTemperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "최저: "
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    private lazy var weekLongWeatherTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(WeekLongWeatherTableViewCell.self, forCellReuseIdentifier: WeekLongWeatherTableViewCell.identifier)
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpUI()
        configure()
        getURL()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    private func setUpUI() {
        view.backgroundColor = UIColor.white
        setUpHierachy()
        setUpLayout()
    }
    
    private func setUpHierachy() {
        [weatherBackgroundImageView, currentWeatherStackView, extremeTemperatureStackView, weekLongWeatherTableView].forEach {
            view.addSubview($0)
        }
        
        [cityNameLabel, temperatureLabel, weatherLabel].forEach {
            currentWeatherStackView.addArrangedSubview($0)
        }
        
        [highestTemperatureLabel, lowestTemperatureLabel].forEach {
            extremeTemperatureStackView.addArrangedSubview($0)
        }
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            weatherBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            currentWeatherStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWeatherStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentWeatherStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            currentWeatherStackView.heightAnchor.constraint(equalTo: currentWeatherStackView.widthAnchor),
            extremeTemperatureStackView.topAnchor.constraint(equalTo: currentWeatherStackView.bottomAnchor, constant: 8),
            extremeTemperatureStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weekLongWeatherTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weekLongWeatherTableView.topAnchor.constraint(equalTo: extremeTemperatureStackView.bottomAnchor, constant: 8),
            weekLongWeatherTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            weekLongWeatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekLongWeatherTableViewCell.identifier, for: indexPath) as? WeekLongWeatherTableViewCell else { return UITableViewCell() }
        cell.dayLabel.text = "임시"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func configure() {
        requestAuthorization()
        weekLongWeatherTableView.dataSource = self
        weekLongWeatherTableView.delegate = self
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
    // 열거형을 이용해 URL 조합
    // (현재 날씨, 일주일 간의 날씨)에 따라 url이 달라지게
    private func getURL() {
        guard let lat = latitude else { return }
        guard let lon = longitude else { return }
        guard let url: URL = URL(string: baseURL + "lat=" + lat + "&lon=" + lon + "&appid=" + appid + "&units=metric") else {
            print("getURL error")
            return
        }
        getRequest(url: url)
    }
    
    private func getRequest(url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = getMethodString
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            print(String(data: data, encoding: .utf8)!)
            do {
                let currentWeather = try JSONDecoder().decode(Current.self, from: data)
                DispatchQueue.main.async {
                    self.setUpBackgroundImage(weather: currentWeather.weather[0].main)
                    self.weatherLabel.text = String(currentWeather.weather[0].main)
                    self.cityNameLabel.text = currentWeather.name
                    self.temperatureLabel.text = String(currentWeather.main.temp) + " ℃"
                    self.highestTemperatureLabel.text! += String(currentWeather.main.temp_max) + " ℃"
                    self.lowestTemperatureLabel.text! += String(currentWeather.main.temp_min) + " ℃"
                }
            }
            catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        dataTask.resume()
    }
    
    private func setUpBackgroundImage(weather: String) {
//        guard let dataAsset: NSDataAsset = NSDataAsset(name: "weatherDescription") else {
//                        return
//                }
//        do {
//            let abc = try JSONDecoder().decode(WeatherId.self, from: dataAsset.data)
//        }
//        catch let DecodingError.dataCorrupted(context) {
//            print(context)
//        } catch let DecodingError.keyNotFound(key, context) {
//            print("Key '\(key)' not found:", context.debugDescription)
//            print("codingPath:", context.codingPath)
//        } catch let DecodingError.valueNotFound(value, context) {
//            print("Value '\(value)' not found:", context.debugDescription)
//            print("codingPath:", context.codingPath)
//        } catch let DecodingError.typeMismatch(type, context)  {
//            print("Type '\(type)' mismatch:", context.debugDescription)
//            print("codingPath:", context.codingPath)
//        } catch {
//            print("error: ", error)
//        }
        switch weather {
        case self.weather.clear:
            weatherBackgroundImageView.image = UIImage(named: self.weather.clear)
        case self.weather.cloudy:
            weatherBackgroundImageView.image = UIImage(named: self.weather.cloudy)
        case self.weather.drizzle:
            weatherBackgroundImageView.image = UIImage(named: self.weather.drizzle)
        case self.weather.rainy:
            weatherBackgroundImageView.image = UIImage(named: self.weather.rainy)
        default:
            weatherBackgroundImageView.image = UIImage(named: self.weather.clear)
        }
    }
}
