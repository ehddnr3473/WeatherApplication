//
//  OtherCityViewController.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/04.
//

import UIKit
import CoreData

/**
 다른 도시의 날씨
 - 도시 이름을 이용하여 현재 날씨 데이터와 예보 데이터를 받아옴.
 - Core Data의 Persistence를 이용하여 viewDidLoad()시 저장한 도시 이름을 받아와서 검색
 */
final class OtherCityViewController: UIViewController {
    
    // MARK: - Properties
    private let apiManager = FetchData()
    private var other = Other()
    private let mainLabelText: String = "도시의 날씨"
    private let searchTextFieldPlaceholder: String = "도시명을 영어로 검색"
    private let cancelButtonTitle: String = "취소"
    private var storedCities: [String] = []
    
    // Layout Constraint 가변 textField
    private lazy var trailingOfSearchTextField: NSLayoutConstraint = searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.standardGap)
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "OtherCityBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = mainLabelText
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textColor = .black
        textField.placeholder = searchTextFieldPlaceholder
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.returnKeyType = .search
        
        let paddingView = UIView(frame: CGRect(x: .zero, y: .zero, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
        
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(cancelButtonTitle, for: UIControl.State.normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(touchUpCancelButton(_:)), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private var cityWeatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = AppStyles.Colors.backgroundColor
        tableView.layer.cornerRadius = AppStyles.cornerRadius
        tableView.layer.borderWidth = AppStyles.borderWidth
        tableView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        tableView.register(CityWeatherTableViewCell.self, forCellReuseIdentifier: CityWeatherTableViewCell.identifier)
        
        return tableView
    }()
    
    private let alert: UIAlertController = {
        let alert = UIAlertController(title: "오류", message: "", preferredStyle: .alert)
        
        return alert
    }()
    
    private let okAction: UIAlertAction = {
        let action = UIAlertAction(title: "확인", style: .default)
        
        return action
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        configure()
        fetchBookMarkCity()
    }
    
    // Core Data fetch
    private func fetchBookMarkCity() {
        guard let resultArray = BookMark.fetchCity() else { return }
        for index in resultArray.indices {
            guard let cityName = resultArray[index].value(forKey: AppText.ModelText.attributeName) as? String else { return }
            storedCities.append(cityName)
            other.appendCityWithName(cityName)
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.requestCurrentWeatherOfCity(cityName)
                self?.requestForecastWeatherOfCity(cityName)
            }
        }
    }
}

// MARK: - View
extension OtherCityViewController {
    private func setUpUI() {
        setUpHierachy()
        setUpLayout()
    }
    
    private func setUpHierachy() {
        [backgroundImageView, titleLabel, searchTextField, cancelButton, cityWeatherTableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configure() {
        cityWeatherTableView.dataSource = self
        cityWeatherTableView.delegate = self
        searchTextField.delegate = self
        
        alert.addAction(okAction)
    }
    
    private func setUpLayout() {
        let safeGuideLine = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safeGuideLine.topAnchor, constant: LayoutConstants.standardGap),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.titleLeading),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.standardGap),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.standardGap),
            trailingOfSearchTextField,
            searchTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.textFieldHeight),
            
            cancelButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: LayoutConstants.standardGap),
            
            cityWeatherTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: LayoutConstants.standardGap),
            cityWeatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.standardGap),
            cityWeatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.standardGap),
            cityWeatherTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: LayoutConstants.heightMultiplier)
        ])
    }

    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
}

// MARK: - REQUEST
extension OtherCityViewController {
    private func requestCurrentWeatherOfCity(_ cityName: String) {
        guard let url: URL = apiManager.getCityWeatherURL(with: cityName) else { return }
        requestCurrentWeatherOfCityData(url)
    }
    
    private func requestCurrentWeatherOfCityData(_ url: URL) {
        apiManager.requestData(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, let weatherOfCity = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
                self.other.appendCityWithWeahter(weatherOfCity)
                
                DispatchQueue.main.async {
                    self.cityWeatherTableView.reloadData()
                }
            case .failure(let error):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !self.alert.isBeingPresented {
                        self.alert.title = AppText.AlertTitle.error
                        self.alert.message = self.apiManager.errorHandler(error)
                        self.present(self.alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func requestForecastWeatherOfCity(_ cityName: String) {
        guard let url: URL = apiManager.getWeatherForecastURL(with: cityName) else { return }
        requestForecastWeatherOfCityData(url)
    }
    
    private func requestForecastWeatherOfCityData(_ url: URL) {
        apiManager.requestData(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self, var forecastWeatherOfCity = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
                forecastWeatherOfCity.list.removeSubrange(NumberConstants.fromEightToEnd)
                self.other.appendCityWithForecast(forecastWeatherOfCity)
                
                DispatchQueue.main.async {
                    self.cityWeatherTableView.reloadData()
                }
            case .failure(let error):
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !self.alert.isBeingPresented {
                        self.alert.title = AppText.AlertTitle.error
                        self.alert.message = self.apiManager.errorHandler(error)
                        self.present(self.alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// MARK: - TableView
extension OtherCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherTableViewCell.identifier, for: indexPath) as? CityWeatherTableViewCell else { return UITableViewCell() }
        
        guard let currentWeather = other.cities[indexPath.row].currentWeather else { return cell }
        
        for index in storedCities.indices {
            if indexPath.row < other.count, currentWeather.name == storedCities[index] {
                cell.bookMarkButton.isSelected = true
                cell.bookMarkButton.tintColor = .systemYellow
                break
            }
        }
        cell.cityNameLabel.text = currentWeather.name
        cell.weatherLabel.text = currentWeather.weather[.zero].description
        cell.temperatureLabel.text = String(Int(currentWeather.main.temp)) + AppText.celsiusString
        
        guard let forecastWeather = other.cities[indexPath.row].forecastWeather else { return cell }
        cell.setUpForecast(forecast: forecastWeather)
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if other.isEmpty {
            return .zero
        } else if other.verifyNil {
            return other.count
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConstants.tableViewItemHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
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
    
    private func removeCell(at indexPath: IndexPath, to tableView: UITableView) {
        other.removeCity(at: indexPath.row)
        cityWeatherTableView.reloadData()
    }
}

// MARK: - TextFieldDelegate
extension OtherCityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cityName: String = textField.text?.capitalized ?? ""
        if verifyCityName(cityName) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.requestCurrentWeatherOfCity(cityName)
                self?.requestForecastWeatherOfCity(cityName)
            }
            textField.text = ""
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func verifyCityName(_ cityName: String) -> Bool {
        if other.isEmpty {
            return true
        } else if cityName == "" && !alert.isBeingPresented {
            alert.title = AppText.AlertTitle.appendFail
            alert.message = AppText.AlertMessage.emptyText
            present(alert, animated: true, completion: nil)
            return false
        } else if other.verifyContains(with: cityName) && !alert.isBeingPresented {
            alert.title = AppText.AlertTitle.appendFail
            alert.message = AppText.AlertMessage.appendFailMessage
            present(alert, animated: true, completion: nil)
            searchTextField.text = ""
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: AnimationConstants.duration) { [weak self] in
            self?.trailingOfSearchTextField.constant = -LayoutConstants.largeGap
            self?.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: AnimationConstants.duration) { [weak self] in
            self?.trailingOfSearchTextField.constant = -LayoutConstants.standardGap
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - Magic Number
private struct LayoutConstants {
    static let standardGap: CGFloat = 8
    static let textFieldHeight: CGFloat = 30
    static let heightMultiplier: CGFloat = 0.7
    static let titleLeading: CGFloat = 15
    static let largeGap: CGFloat = 50
    static let tableViewItemHeight: CGFloat = 200
}

private struct AnimationConstants {
    static let duration: TimeInterval = 0.2
}

private struct NumberConstants {
    static let fromEightToEnd = 8...
}
