//
//  AnotherCities.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/11/06.
//

import Foundation


/// Other Cities Model Object
struct OtherCities {
    var cities: [AnotherCity] = []
    
    var isEmpty: Bool {
        cities.isEmpty
    }
    
    var count: Int {
        cities.count
    }
    
    var verifyNil: Bool {
        if cities.filter({ $0.currentWeather == nil || $0.forecastWeather == nil }).count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func verifyContains(with cityName: String) -> Bool {
        cities.contains(where: { $0.name == cityName })
    }
    
    mutating func appendCityWithName(_ cityName: String) {
        cities.append(AnotherCity(name: cityName))
    }
    
    mutating func appendCityWithWeahter(_ weatherOfCity: WeatherOfCity) {
        if cities.contains(where: { $0.name == weatherOfCity.name }) {
            for index in cities.indices {
                if weatherOfCity.name == cities[index].name {
                    cities[index].currentWeather = weatherOfCity
                    break
                }
            }
        } else {
            cities.append(AnotherCity(name: weatherOfCity.name, currentWeather: weatherOfCity))
        }
    }
    
    mutating func appendCityWithForecast(_ forecastWeatherOfCity: Forecast) {
        if cities.contains(where: { $0.name == forecastWeatherOfCity.city.name }) {
            for index in cities.indices {
                if forecastWeatherOfCity.city.name == cities[index].name {
                    cities[index].forecastWeather = forecastWeatherOfCity
                    break
                }
            }
        } else {
            cities.append(AnotherCity(name: forecastWeatherOfCity.city.name, forecastWeather: forecastWeatherOfCity))
        }
    }
    
    mutating func removeCity(at index: Int) {
        cities.remove(at: index)
    }
}
