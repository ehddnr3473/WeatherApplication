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
final class OtherCitiesViewController: UIViewController, WeatherControllable, Storable {
    typealias Model = OtherCities
    
    // MARK: - Properties
    var model = Model()
    let networkManager = NetworkManager()
    var storedCities = [String]()
    
    // Layout Constraint 가변 textField: 취소 버튼이 오른쪽에서 나오는 것을 위해
    private lazy var trailingOfSearchTextField: NSLayoutConstraint = searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                                                                               constant: -LayoutConstants.offset)
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: StringConstants.backgroundImageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = StringConstants.mainLabelText
        label.textColor = AppStyles.Colors.mainColor
        label.font = .boldSystemFont(ofSize: LayoutConstants.mediumFontSize)
        
        return label
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textColor = .black
        textField.placeholder = StringConstants.searchTextFieldPlaceholder
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = AppStyles.cornerRadius
        textField.layer.borderWidth = AppStyles.borderWidth
        textField.returnKeyType = .search
        textField.keyboardType = .alphabet
        
        textField.leftView = UIView(frame: CGRect(x: .zero,
                                                  y: .zero,
                                                  width: LayoutConstants.offset,
                                                  height: textField.frame.height))
        textField.leftViewMode = UITextField.ViewMode.always
        
        return textField
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(StringConstants.cancelButtonTitle, for: UIControl.State.normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(touchUpCancelButton), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private let cityWeatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = AppStyles.Colors.backgroundColor
        tableView.layer.cornerRadius = AppStyles.cornerRadius
        tableView.layer.borderWidth = AppStyles.borderWidth
        tableView.layer.borderColor = AppStyles.Colors.mainColor.cgColor
        
        tableView.register(CityWeatherTableViewCell.self,
                           forCellReuseIdentifier: CityWeatherTableViewCell.identifier)
        
        return tableView
    }()
    
    lazy var alert: UIAlertController = {
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
        
        fetchBookmarkCity() { cityName in
            self.model.appendCityWithName(cityName)
            Task {
                self.requestCurrentWeatherOfCity(cityName)
                self.requestForecastWeatherOfCity(cityName)
            }
        }
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstants.offset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.titleLeading),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.offset),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.offset),
            trailingOfSearchTextField,
            searchTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.textFieldHeight),
            
            cancelButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: LayoutConstants.offset),
            
            cityWeatherTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: LayoutConstants.offset),
            cityWeatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.offset),
            cityWeatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.offset),
            cityWeatherTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: LayoutConstants.heightMultiplier)
        ])
    }

    @objc func touchUpCancelButton() {
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
        guard let url = networkManager.getCurrentWeatherURL(with: cityName) else { return }
        Task {
            await requestCurrentWeather(with: url)
        }
    }
    
    private func requestCurrentWeather(with url: URL) async {
        do {
            let data = try await networkManager.requestData(with: url)
            guard let weather = DecodingManager.decode(with: data, modelType: WeatherOfCity.self) else { return }
            model.appendCityWithWeahter(weather)
            reloadtableView()
        } catch {
            alertWillAppear(alert, networkManager.errorMessage(error))
        }
    }
    
    private func requestForecastWeatherOfCity(_ cityName: String) {
        guard let url = networkManager.getForecastURL(with: cityName) else { return }
        Task {
            await requestForecast(with: url)
        }
    }
    
    private func requestForecast(with url: URL) async {
        do {
            let data = try await networkManager.requestData(with: url)
            guard var forecast = DecodingManager.decode(with: data, modelType: Forecast.self) else { return }
            forecast.list.removeSubrange(NumberConstants.fromEightToEnd)
            model.appendCityWithForecast(forecast)
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
        
        guard let currentWeather = model.cities[indexPath.row].currentWeather else { return cell }
        
        // 즐겨찾기 버튼 설정
        for index in storedCities.indices {
            if indexPath.row < model.count, currentWeather.name == storedCities[index] {
                cell.bookmarkButton.isSelected = true
                cell.bookmarkButton.tintColor = .systemYellow
                break
            }
        }
        
        // 날씨 데이터 설정
        cell.cityNameLabel.text = currentWeather.name
        cell.weatherLabel.text = currentWeather.weather[.zero].description
        cell.temperatureLabel.text = String(Int(currentWeather.main.temp)) + AppText.celsiusString
        
        guard let forecastWeather = model.cities[indexPath.row].forecastWeather else { return cell }
        cell.setUpForecast(forecast: forecastWeather)
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.isEmpty {
            return .zero
        } else if model.verifyNil {
            return model.count
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
            deleteCity(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func deleteCity(at indexPath: IndexPath) {
        model.removeCity(at: indexPath.row)
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
        if cityName == "" {
            alertWillAppear(alert, ErrorMessage.emptyText)
            return false
        } else if model.isEmpty {
            return true
        } else if model.verifyContains(with: cityName) {
            alertWillAppear(alert, ErrorMessage.appendFailMessage)
            searchTextField.text = ""
            return false
        } else {
            return true
        }
    }
    
    // 취소 버튼 오른쪽에서 나타나는 애니메이션
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: AnimationConstants.duration) {
            if AppText.language == AppText.korea {
                self.trailingOfSearchTextField.constant = -LayoutConstants.krLargeOffset
            } else {
                self.trailingOfSearchTextField.constant = -LayoutConstants.enLargeOffset
            }
            self.view.layoutIfNeeded()
        }
    }
    
    // 취소 버튼 오른쪽으로 사라지는 애니메이션
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: AnimationConstants.duration) {
            self.trailingOfSearchTextField.constant = -LayoutConstants.offset
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
    static let offset: CGFloat = 8
    static let textFieldHeight: CGFloat = 30
    static let heightMultiplier: CGFloat = 0.7
    static let titleLeading: CGFloat = 15
    static let krLargeOffset: CGFloat = 50
    static let enLargeOffset: CGFloat = 60
    static let tableViewItemHeight: CGFloat = 200
    static let mediumFontSize: CGFloat = 30
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
