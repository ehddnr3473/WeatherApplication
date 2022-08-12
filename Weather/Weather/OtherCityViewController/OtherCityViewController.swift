//
//  OtherCityViewController.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/04.
//

import UIKit

final class OtherCityViewController: UIViewController {

    // MARK: - Properties
    private let apiManager = FetchData()
    private let mainLabelText: String = "도시의 날씨"
    private let searchTextFieldPlaceholder: String = "도시명으로 검색"
    private let searchButtonTitle: String = "추가"
    private var cities: [WeatherOfCity] = []
    static var forecasts: [Forecast] = []
    
    private var dataSourcesOfTableView: [UITableViewDataSource] = []
    private var delegatesOfTableView: [UITableViewDelegate] = []
    private let cityWeatherTableViewDataSource = CityWeatherTableViewDataSource()
    private let cityWeatherTableViewDelegate = CityWeatherTableViewDelegate()
    private let cell = CityWeatherTableViewCell()
    
    private var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(named: "CityBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = mainLabelText
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textColor = UIColor.white
        textField.placeholder = searchTextFieldPlaceholder
        textField.backgroundColor = UIColor.lightGray
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
        
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(searchButtonTitle, for: UIControl.State.normal)
        button.tintColor = UIColor.lightGray
//        button.isEnabled = false
        
        button.addTarget(self, action: #selector(touchUpSearchButton(_:)), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private var cityWeatherTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        tableView.register(CityWeatherTableViewCell.self, forCellReuseIdentifier: CityWeatherTableViewCell.identifier)
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        configure()
    }
}

extension OtherCityViewController: UITextFieldDelegate {
    private func setUpUI() {
        setUpHierachy()
        setUpLayout()
    }
    
    private func setUpHierachy() {
        [backgroundImageView, mainLabel, searchTextField, searchButton, cityWeatherTableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configure() {
        dataSourcesOfTableView = [cityWeatherTableViewDataSource]
        cityWeatherTableView.dataSource = dataSourcesOfTableView[0]
        delegatesOfTableView = [cityWeatherTableViewDelegate]
        cityWeatherTableView.delegate = delegatesOfTableView[0]
        searchTextField.delegate = self
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchTextField.heightAnchor.constraint(equalToConstant: 30),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            searchButton.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            cityWeatherTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            cityWeatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cityWeatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cityWeatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    @IBAction func touchUpSearchButton(_ sender: UIButton) {
        let cityName: String = searchTextField.text ?? ""
        requestCurrentWeatherOfCity(cityName: cityName)
        DispatchQueue.global().async {
            self.requestForecastWeatherOfCity(cityName: cityName)
        }
    }
}

extension OtherCityViewController {
    // MARK: - REQUEST
    private func requestCurrentWeatherOfCity(cityName: String) {
        guard let url: URL = apiManager.getCityWeatherURL(cityName: cityName) else { return }
        requestCurrentWeatherOfCityData(url: url)
    }
    
    private func requestCurrentWeatherOfCityData(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] (isSuccess, data) in
            if isSuccess {
                guard let self = self, let weatherOfCity = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
                self.cities.append(weatherOfCity)
                self.cityWeatherTableViewDataSource.cities = self.cities
                DispatchQueue.main.async {
                    self.cityWeatherTableView.reloadData()
                }
            }
        })
    }
    
    private func requestForecastWeatherOfCity(cityName: String) {
        guard let url: URL = apiManager.getWeatherForecastURL(cityName: cityName) else { return }
        requestForecastWeatherOfCityData(url: url)
    }
    
    private func requestForecastWeatherOfCityData(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] (isSuccess, data) in
            if isSuccess {
                guard let self = self, var forecastWeatherOfCity = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
                forecastWeatherOfCity.list.removeSubrange(0...2)
                forecastWeatherOfCity.list.removeSubrange(8...)
                OtherCityViewController.forecasts.append(forecastWeatherOfCity)
                DispatchQueue.main.async {
                    self.cityWeatherTableView.reloadData()
                }
            }
        })
    }
}
