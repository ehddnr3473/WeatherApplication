//
//  FetchData.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/05.
//

import Foundation

struct FetchData {
    
    enum FetchError: Error {
        case apiKeyError
        case cityNameError
        case unknown
    }
    
    private let getMethodString: String = "GET"
    private let appid = Bundle.main.apiKey
    
    func getCityWeatherURL(cityName: String) -> URL? {
        var baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?")
        let cityName = URLQueryItem(name: "q", value: cityName)
        let language = URLQueryItem(name: "lang", value: "kr")
        let key = URLQueryItem(name: "appid", value: appid)
        let units = URLQueryItem(name: "units", value: "metric")
        
        baseURL?.queryItems = [cityName, language, key, units]
        return baseURL?.url
    }
    
    func getReverseGeocodingURL(lat: String, lon: String) -> URL? {
        var baseURL = URLComponents(string: "https://api.openweathermap.org/geo/1.0/reverse?")
        let latitude = URLQueryItem(name: "lat", value: lat)
        let longitude = URLQueryItem(name: "lon", value: lon)
        let key = URLQueryItem(name: "appid", value: appid)
        
        baseURL?.queryItems = [latitude, longitude, key]
        return baseURL?.url
    }
    
    func getWeatherForecastURL(cityName: String) -> URL? {
        var baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast?")
        let cityName = URLQueryItem(name: "q", value: cityName)
        let language = URLQueryItem(name: "lang", value: "kr")
        let key = URLQueryItem(name: "appid", value: appid)
        let units = URLQueryItem(name: "units", value: "metric")
        
        baseURL?.queryItems = [cityName, language, key, units]
        return baseURL?.url
    }
    
    func requestData(url: URL, completion: @escaping (Result<Data, FetchError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = getMethodString
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                #if DEBUG
                print("Error: error calling GET")
                print(error!)
                #endif
                return
            }
            guard let data = data else {
                #if DEBUG
                print("Error: Did not receive data")
                #endif
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if !(response.statusCode == 200) {
                switch response.statusCode {
                case 401:
                    completion(.failure(FetchError.apiKeyError))
                case 404:
                    completion(.failure(FetchError.cityNameError))
                default:
                    completion(.failure(FetchError.unknown))
                }
            }
            completion(.success(data))
        })
        dataTask.resume()
    }
}
