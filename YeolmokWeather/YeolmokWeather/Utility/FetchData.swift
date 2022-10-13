//
//  FetchData.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/05.
//

import Foundation
import CoreLocation

struct FetchData {
    private let getMethodString = "GET"
    private let appid = Bundle.main.apiKey
    
    enum FetchError: Error {
        case apiKeyError
        case cityNameError
        case internetConnectionProblem
        case didNotReceiveData
        case undefined
    }
    
    func errorHandler(_ error: Error) -> String {
        var message = ""
        switch error {
        case FetchError.apiKeyError:
            message = "알 수 없는 오류가 발생하였습니다."
            return message
        case FetchError.cityNameError:
            message = "도시 이름을 다시 확인해주세요."
            return message
        case FetchError.internetConnectionProblem:
            message = "인터넷 연결을 확인해주세요."
            return message
        case FetchError.undefined:
            message = "알 수 없는 오류가 발생하였습니다."
            return message
        default:
            message = "알 수 없는 오류가 발생하였습니다."
            return message
        }
    }
    
    func getReverseGeocodingURL(with location: CLLocationCoordinate2D) -> URL? {
        var baseURL = URLComponents(string: "https://api.openweathermap.org/geo/1.0/reverse?")
        let latitude = URLQueryItem(name: "lat", value: String(location.latitude))
        let longitude = URLQueryItem(name: "lon", value: String(location.longitude))
        let key = URLQueryItem(name: "appid", value: appid)
        
        baseURL?.queryItems = [latitude, longitude, key]
        return baseURL?.url
    }
    
    func getCityWeatherURL(with cityName: String) -> URL? {
        var baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?")
        let cityName = URLQueryItem(name: "q", value: cityName)
        let language = URLQueryItem(name: "lang", value: "kr")
        let key = URLQueryItem(name: "appid", value: appid)
        let units = URLQueryItem(name: "units", value: "metric")
        
        baseURL?.queryItems = [cityName, language, key, units]
        return baseURL?.url
    }
    
    func getWeatherForecastURL(with cityName: String) -> URL? {
        var baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast?")
        let cityName = URLQueryItem(name: "q", value: cityName)
        let language = URLQueryItem(name: "lang", value: "kr")
        let key = URLQueryItem(name: "appid", value: appid)
        let units = URLQueryItem(name: "units", value: "metric")
        
        baseURL?.queryItems = [cityName, language, key, units]
        return baseURL?.url
    }
    
    func requestData(with url: URL, completion: @escaping (Result<Data, FetchError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = getMethodString
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(.failure(FetchError.internetConnectionProblem))
                return
            }
            
            guard let data = data else {
                completion(.failure(FetchError.didNotReceiveData))
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
                    completion(.failure(FetchError.undefined))
                }
            }
            completion(.success(data))
        })
        dataTask.resume()
    }
}
