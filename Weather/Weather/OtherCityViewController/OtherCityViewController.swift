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
    private var mainLabelText: String = "도시의 날씨"
    private let searchTextFieldPlaceholder: String = "도시명으로 검색"
    private let searchButtonTitle: String = "추가"
    private var cities: [OtherCityWeather] = []
    
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

extension OtherCityViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private func setUpUI() {
        setUpHierachy()
        setUpLayout()
        view.backgroundColor = UIColor.black
    }
    
    private func setUpHierachy() {
        [mainLabel, searchTextField, searchButton, cityWeatherTableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configure() {
        cityWeatherTableView.dataSource = self
        cityWeatherTableView.delegate = self
        searchTextField.delegate = self
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherTableViewCell.identifier, for: indexPath) as? CityWeatherTableViewCell else {
            return UITableViewCell()
        }
        cell.cityNameLabel.text = cities[indexPath.row].name
        cell.weatherLabel.text = cities[indexPath.row].weather[0].description
        cell.temperatureLabel.text = String(Int(cities[indexPath.row].main.temp))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cities.count
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if verifyTextField() {
//            searchButton.isEnabled = true
//        }
//    }
//
//    private func verifyTextField() -> Bool {
//        return searchTextField.hasText
//    }

    @IBAction func touchUpSearchButton(_ sender: UIButton) {
        let cityName: String = searchTextField.text ?? ""
        requestCityWeather(cityName: cityName)
    }
    
    // MARK: - REQUEST
    private func requestCityWeather(cityName: String) {
        guard let url: URL = apiManager.getCityWeatherURL(cityName: cityName) else { return }
        requestData(url: url)
    }
    
    private func requestData(url: URL) {
        apiManager.requestData(url: url, completion: { (isSuccess, data) in
            if isSuccess {
                guard let otherCityWeather = DecodingManager.decode(with: data, modelType: OtherCityWeather.self) else { return }
                self.cities.append(otherCityWeather)
                self.cityWeatherTableView.reloadData()
            }
        })
    }
    
}
