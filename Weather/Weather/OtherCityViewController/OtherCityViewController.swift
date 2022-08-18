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
    private let searchTextFieldPlaceholder: String = "도시명을 영어로 검색"
    private let searchButtonTitle: String = "추가"
    private var cities: [WeatherOfCity] = []
    private var forecasts: [Forecast] = []
    
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
        
        button.addTarget(self, action: #selector(touchUpSearchButton(_:)), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private var cityWeatherTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = AppStyles.Colors.backgroundColor
        tableView.layer.cornerRadius = AppStyles.cornerRadius
        tableView.layer.borderWidth = AppStyles.borderWidth
        tableView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        tableView.register(CityWeatherTableViewCell.self, forCellReuseIdentifier: CityWeatherTableViewCell.identifier)
        
        return tableView
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

extension OtherCityViewController {
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
        cityWeatherTableView.dataSource = self
        cityWeatherTableView.delegate = self
        
        alert.addAction(okAction)
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
        if verifyCityName(cityName: cityName) {
            requestCurrentWeatherOfCity(cityName: cityName)
            DispatchQueue.global().async {
                self.requestForecastWeatherOfCity(cityName: cityName)
            }
            searchTextField.text = ""
        } else {
            if !alert.isBeingPresented {
                alert.title = AppText.AlertTitle.appendFail
                alert.message = AppText.AlertMessage.appendFailMessage
                present(alert, animated: true, completion: nil)
                searchTextField.text = ""
            }
        }
    }
    
    private func verifyCityName(cityName: String) -> Bool {
        if cityName == "" && !alert.isBeingPresented {
            alert.title = AppText.AlertTitle.appendFail
            alert.message = AppText.AlertMessage.emptyText
            present(alert, animated: true, completion: nil)
            return false
        }
        
        let cityName = cityName.capitalized
        
        if cities.isEmpty {
            return true
        }
        
        for i in 0..<cities.count {
            if cities[i].name == cityName {
                return false
            }
        }
        return true
    }
}

extension OtherCityViewController {
    // MARK: - REQUEST
    private func requestCurrentWeatherOfCity(cityName: String) {
        guard let url: URL = apiManager.getCityWeatherURL(cityName: cityName) else { return }
        requestCurrentWeatherOfCityData(url: url)
    }
    
    private func requestCurrentWeatherOfCityData(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let weatherOfCity = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
                self.cities.append(weatherOfCity)
                DispatchQueue.main.async {
                    self.cityWeatherTableView.reloadData()
                }
            case .failure(let error):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !self.alert.isBeingPresented {
                        self.alert.title = AppText.AlertTitle.error
                        self.alert.message = self.apiManager.errorHandler(error: error)
                        self.present(self.alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    private func requestForecastWeatherOfCity(cityName: String) {
        guard let url: URL = apiManager.getWeatherForecastURL(cityName: cityName) else { return }
        requestForecastWeatherOfCityData(url: url)
    }
    
    private func requestForecastWeatherOfCityData(url: URL) {
        apiManager.requestData(url: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, var forecastWeatherOfCity = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
                forecastWeatherOfCity.list.removeSubrange(0...2)
                forecastWeatherOfCity.list.removeSubrange(8...)
                self.forecasts.append(forecastWeatherOfCity)
                DispatchQueue.main.async {
                    self.cityWeatherTableView.reloadData()
                }
            case .failure(let error):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !self.alert.isBeingPresented {
                        self.alert.title = AppText.AlertTitle.error
                        self.alert.message = self.apiManager.errorHandler(error: error)
                        self.present(self.alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
}

extension OtherCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherTableViewCell.identifier, for: indexPath) as? CityWeatherTableViewCell else {
            return UITableViewCell()
        }
        cell.cityNameLabel.text = cities[indexPath.row].name
        cell.weatherLabel.text = cities[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(cities[indexPath.row].main.temp)) + AppText.celsiusString
        cell.prepare(forecast: forecasts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = AppStyles.borderWidth
        cell.layer.borderColor = AppStyles.Colors.mainColor.cgColor
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeCell(at: indexPath, to: tableView)
        }
    }
    
    func removeCell(at indexPath: IndexPath, to tableView: UITableView) {
        forecasts.remove(at: indexPath.row)
        cities.remove(at: indexPath.row)
        tableView.reloadData()
    }
}
