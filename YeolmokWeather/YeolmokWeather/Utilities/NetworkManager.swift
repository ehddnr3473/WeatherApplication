//
//  NetworkManager.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/05.
//

import Foundation
import CoreLocation

/// OpenWeather API 호출 관련
struct NetworkManager {
    private let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    /**
     API 호출 관련 Custom Error
     - apiKeyError: API key 오류
     - cityNameError: 잘못된 도시 이름 오류
     - internetConnectionProblem: 인터넷 연결 오류
     - undefined: 알 수 없는 오류
     */
    enum FetchError: Error, CaseIterable {
        case apiKeyError
        case cityNameError
        case internetConnectionProblem
        case undefined
    }
    
    /// 에러 종류에 따라 Alert으로 띄울 메시지 반환
    /// - Parameter error: FetchError
    /// - Returns: 에러 메시지
    func errorMessage(_ error: Error) -> String {
        switch error {
        case FetchError.apiKeyError:
            return ErrorMessage.apiKeyError
        case FetchError.cityNameError:
            return ErrorMessage.cityNameError
        case FetchError.undefined:
            return ErrorMessage.undefined
        default:
            return ErrorMessage.internetConnectionProblem
        }
    }
    
    /// 위도와 경도로 도시 이름을 GET
    /// - Parameter location: 위도와 경도
    /// - Returns: API ReverseGeocoding URL
    func getReverseGeocodingURL(with location: CLLocationCoordinate2D) -> URL? {
        let baseURL = URL(string: "https://api.openweathermap.org")
        var urlComponents = URLComponents()
        let latitude = URLQueryItem(name: "lat", value: String(location.latitude))
        let longitude = URLQueryItem(name: "lon", value: String(location.longitude))
        let key = URLQueryItem(name: "appid", value: apiKey)
        
        urlComponents.path = "/geo/1.0/reverse"
        urlComponents.queryItems = [latitude, longitude, key]
        return urlComponents.url(relativeTo: baseURL)
    }
    
    /// 도시 이름으로 현재 날씨 GET
    /// - Parameter cityName: 도시 이름
    /// - Returns: API 현재 날씨 URL
    func getCurrentWeatherURL(with cityName: String) -> URL? {
        let baseURL = URL(string: "https://api.openweathermap.org")
        var urlComponents = URLComponents()
        let cityName = URLQueryItem(name: "q", value: cityName)
        let language = URLQueryItem(name: "lang", value: AppText.language)
        let key = URLQueryItem(name: "appid", value: apiKey)
        let units = URLQueryItem(name: "units", value: "metric")
        
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [cityName, language, key, units]
        return urlComponents.url(relativeTo: baseURL)
    }
    
    /// 도시 이름으로 날씨 예보 GET
    /// - Parameter cityName: 도시 이름
    /// - Returns: API 날씨 예보 URL
    func getForecastURL(with cityName: String) -> URL? {
        let baseURL = URL(string: "https://api.openweathermap.org")
        var urlComponents = URLComponents()
        let cityName = URLQueryItem(name: "q", value: cityName)
        let language = URLQueryItem(name: "lang", value: AppText.language)
        let key = URLQueryItem(name: "appid", value: apiKey)
        let units = URLQueryItem(name: "units", value: "metric")
        
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [cityName, language, key, units]
        return urlComponents.url(relativeTo: baseURL)
    }
    
    // 네트워크 통신
    func requestData(with url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw FetchError.undefined }
        if !(response.statusCode == 200) {
            switch response.statusCode {
            case 401:
                throw FetchError.apiKeyError
            case 404:
                throw FetchError.cityNameError
            default:
                throw FetchError.undefined
            }
        }
        return data
    }
}

// ErrorMessage Namespace
private enum ErrorMessage {
    static let apiKeyError = "ApiKeyError".localized
    static let cityNameError = "CityNameError".localized
    static let internetConnectionProblem = "InternetConnectionProblem".localized
    static let undefined = "Undefined".localized
}
