//
//  FetchData.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/05.
//

import Foundation

struct FetchData {
    private let getMethodString: String = "GET"
    private let appid = Bundle.main.apiKey
    
    func getCurrentWeatherURL(lat: String, lon: String) -> URL? {
        var baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather?")
        let latitude = URLQueryItem(name: "lat", value: lat)
        let longitude = URLQueryItem(name: "lon", value: lon)
        let language = URLQueryItem(name: "lang", value: "kr")
        let key = URLQueryItem(name: "appid", value: appid)
        let units = URLQueryItem(name: "units", value: "metric")
        
        baseURL?.queryItems = [latitude, longitude, language, key, units]
        return baseURL?.url
    }
    
    func getOtherCityWeatherURL() {
        
    }
    
    func requestData(url: URL, completion: @escaping (Bool, Data) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = getMethodString
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
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
            DispatchQueue.main.async {
                completion(true, data)
            }
        })
        dataTask.resume()
    }
}
