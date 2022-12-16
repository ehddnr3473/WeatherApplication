//
//  OtherCitiesViewController.swift
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
final class OtherCitiesViewController: UIViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager()
    private var other = Other()
    private var storedCities: [String] = []
    
    // Layout Constraint 가변 textField
    private lazy var trailingOfSearchTextField: NSLayoutConstraint = searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.standardGap)
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: StringConstants.backgroundImageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = StringConstants.mainLabelText
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textColor = .black
        textField.placeholder = StringConstants.searchTextFieldPlaceholder
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 2
        textField.returnKeyType = .search
        
        textField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 10, height: textField.frame.height))
        textField.leftViewMode = UITextField.ViewMode.always
        
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(StringConstants.cancelButtonTitle, for: UIControl.State.normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(touchUpCancelButton(_:)), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private let cityWeatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = AppStyles.Colors.backgroundColor
        tableView.layer.cornerRadius = AppStyles.cornerRadius
        tableView.layer.borderWidth = AppStyles.borderWidth
        tableView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        tableView.register(CityWeatherTableViewCell.self, forCellReuseIdentifier: CityWeatherTableViewCell.identifier)
        
        return tableView
    }()
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "AlertTitle".localized, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ActionTitle".localized, style: .default)
        alert.addAction(action)
        
        return alert
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
            guard let cityName = resultArray[index].value(forKey: CoreDataModel.attributeName) as? String else { return }
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
extension OtherCitiesViewController {
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
    
    @MainActor private func reloadtableView() {
        cityWeatherTableView.reloadData()
    }
}

// MARK: - REQUEST
extension OtherCitiesViewController {
    private func requestCurrentWeatherOfCity(_ cityName: String) {
        guard let url: URL = networkManager.getCurrentWeatherURL(with: cityName) else { return }
        Task {
            await requestCurrentWeather(with: url)
        }
    }
    
    private func requestCurrentWeather(with url: URL) async {
        do {
            let data = try await networkManager.requestData(with: url)
            guard let weather = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
            other.appendCityWithWeahter(weather)
            reloadtableView()
        } catch {
            alertWillAppear(alert, networkManager.errorMessage(error))
        }
    }
    
    private func requestForecastWeatherOfCity(_ cityName: String) {
        guard let url: URL = networkManager.getForecastURL(with: cityName) else { return }
        Task {
            await requestForecast(with: url)
        }
    }
    
    private func requestForecast(with url: URL) async {
        do {
            let data = try await networkManager.requestData(with: url)
            guard var forecast = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
            forecast.list.removeSubrange(NumberConstants.fromEightToEnd)
            self.other.appendCityWithForecast(forecast)
            reloadtableView()
        } catch {
            alertWillAppear(alert, networkManager.errorMessage(error))
        }
    }
}

// MARK: - TableView
extension OtherCitiesViewController: UITableViewDelegate, UITableViewDataSource {
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
        reloadtableView()
    }
}

// MARK: - TextFieldDelegate
extension OtherCitiesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cityName: String = textField.text?.capitalized ?? ""
        if verifyCityName(cityName) {
            Task {
                requestCurrentWeatherOfCity(cityName)
                requestForecastWeatherOfCity(cityName)
            }
            textField.text = ""
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func verifyCityName(_ cityName: String) -> Bool {
        if other.isEmpty {
            return true
        } else if cityName == "" {
            alertWillAppear(alert, ErrorMessage.emptyText)
            return false
        } else if other.verifyContains(with: cityName) {
            alertWillAppear(alert, ErrorMessage.appendFailMessage)
            searchTextField.text = ""
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: AnimationConstants.duration) {
            if AppText.language == "kr" {
                self.trailingOfSearchTextField.constant = -LayoutConstants.krLargeGap
            } else {
                self.trailingOfSearchTextField.constant = -LayoutConstants.enLargeGap
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: AnimationConstants.duration) {
            self.trailingOfSearchTextField.constant = -LayoutConstants.standardGap
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Magic Number
private enum StringConstants {
    static let mainLabelText = "City weather".localized
    static let searchTextFieldPlaceholder = "Placeholder".localized
    static let cancelButtonTitle = "Cancel".localized
    static let backgroundImageName = "OtherCitiesBackground"
}

private enum LayoutConstants {
    static let standardGap: CGFloat = 8
    static let textFieldHeight: CGFloat = 30
    static let heightMultiplier: CGFloat = 0.7
    static let titleLeading: CGFloat = 15
    static let krLargeGap: CGFloat = 50
    static let enLargeGap: CGFloat = 60
    static let tableViewItemHeight: CGFloat = 200
}

private enum AnimationConstants {
    static let duration: TimeInterval = 0.2
}

private enum NumberConstants {
    static let fromEightToEnd = 8...
}

private enum ErrorMessage {
    static let appendFailMessage = "AppendFailMessage".localized
    static let emptyText = "EmptyText".localized
    static let undefined = "Undefined".localized
}
