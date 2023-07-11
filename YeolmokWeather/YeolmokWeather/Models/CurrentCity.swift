//
//  CurrentCity.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/11/06.
//

import Foundation

struct CurrentCity {
    private(set) var name: String?
    private(set) var weather: String?
    private(set) var temperature: Double?
    private(set) var forecast: Forecast?
    private(set) var forecasts: [Forecast] = []
    
    mutating func setCityName(with cityName: String) {
        name = cityName
    }
    
    mutating func setCurrentWeather(weather: String, temperature: Double) {
        self.weather = weather
        self.temperature = temperature
    }
    
    mutating func clear() {
        forecast = nil
        forecasts.removeAll()
    }
}

// MARK: - Forecast
extension CurrentCity {
    // 24시간 동안의 예보
    mutating func setUpDayForecast(with forecast: Forecast) {
        let trimmedList = Array(forecast.list.prefix(NumberConstants.numberOfItemsInSection))
        self.forecast = Forecast(list: trimmedList, city: forecast.city)
    }
    
    // 다음날 ~ 3일 후 예보
    mutating func appendForecast(with forecast: Forecast) {
        // 다음날 예보 추가
        let trimmedFromForecastListTomorrow =
            appendForecastTomorrow(
                list: forecast.list,
                city: forecast.city
            )
        
        // 2일 후 예보 추가
        let trimmedFromForecastAfterTwoDay =
            appendForecastAfterTwoDay(
                list: trimmedFromForecastListTomorrow,
                city: forecast.city
            )
        
        // 3일 후 예보 추가
        appendForecastAfterThreeDay(list: trimmedFromForecastAfterTwoDay, city: forecast.city)
    }
    
    // MARK: - Private.
    // 다음 날 예보
    mutating private func appendForecastTomorrow(list: [Forecast.List], city: Forecast.City) -> [Forecast.List] {
        let trimmedList = Array(list.drop(while: { compare(to: $0.date) }))
        
        forecasts.append(
            Forecast(
                list: Array(trimmedList.prefix(NumberConstants.numberOfItemsInSection)),
                city: city
            )
        )
        
        return Array(trimmedList.dropFirst(NumberConstants.numberOfItemsInSection))
    }
    
    // 2일 후 예보
    mutating private func appendForecastAfterTwoDay(list: [Forecast.List], city: Forecast.City) -> [Forecast.List] {
        forecasts.append(
            Forecast(
                list: Array(list.prefix(NumberConstants.numberOfItemsInSection)),
                city: city
            )
        )
        
        return Array(list.dropFirst(NumberConstants.numberOfItemsInSection)
                         .prefix(NumberConstants.numberOfItemsInSection))
    }
    
    // 3일 후 예보
    mutating private func appendForecastAfterThreeDay(list: [Forecast.List], city: Forecast.City) {
        forecasts.append(Forecast(list: list, city: city))
    }
    
    private func compare(to date: TimeInterval) -> Bool {
        let day = Date()
        let nextDay = Date(timeIntervalSince1970: date)
        
        if dayToString(from: day) == dayToString(from: nextDay) {
            return true
        } else {
            return false
        }
    }
    
    private func dayToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = StringConstants.dateFormat
        
        return dateFormatter.string(from: date)
    }
}

private enum NumberConstants {
    static let numberOfItemsInSection = 8
}

private enum StringConstants {
    static let dateFormat = "dd"
}
