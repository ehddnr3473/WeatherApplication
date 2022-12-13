//
//  CurrentCity.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/11/06.
//

import Foundation

/// Current Weather Model Object
struct CurrentCity {
    var name: String?
    var weather: String?
    var temperature: Double?
    var forecast: Forecast?
    var forecasts: [Forecast] = []
    
    var isEmpty: Bool {
        forecasts.isEmpty
    }
    
    var count: Int {
        forecasts.count
    }
    
    var forecastIsNil: Bool {
        forecast == nil
    }
    
    mutating func setCityName(with cityName: String) {
        self.name = cityName
    }
    
    mutating func setCurrentWeather(weather: String, temperature: Double) {
        self.weather = weather
        self.temperature = temperature
    }
    // For 24시간 동안의 예보
    mutating func setUpDayForecast(with forecast: Forecast) {
        var forecast = forecast
        if forecast.list.count > NumberConstants.numberOfItemsInSection {
            forecast.list.removeSubrange(NumberConstants.fromEightToEnd)
        }
        
        self.forecast = forecast
    }
    
    // For 3일간의 예보
    mutating func appendForecastsTomorrow(with forecast: Forecast) {
        var forecast = forecast
        for index in forecast.list.indices {
            if compare(to: forecast.list[index].date) {
                forecast.list.removeSubrange(.zero..<index)
                var copiedForecast = forecast
                if copiedForecast.list.count > NumberConstants.numberOfItemsInSection,
                        forecast.list.count >= NumberConstants.numberOfItemsInSection {
                    
                    copiedForecast.list.removeSubrange(NumberConstants.fromEightToEnd)
                    forecast.list.removeSubrange(NumberConstants.fromZeroToSeven)
                    
                    forecasts.append(copiedForecast)
                    appendForecastsDaysAfterTomorrow(with: forecast)
                }
                break
            }
        }
    }
    
    mutating private func appendForecastsDaysAfterTomorrow(with forecast: Forecast) {
        var dayAfterTomorrowForecast = forecast
        if dayAfterTomorrowForecast.list.count > NumberConstants.numberOfItemsInSection {
            dayAfterTomorrowForecast.list.removeSubrange(NumberConstants.fromEightToEnd)
            forecasts.append(dayAfterTomorrowForecast)
        }
        
        var twoDaysAfterTomorrowForecast = forecast
        if twoDaysAfterTomorrowForecast.list.count >= NumberConstants.numberOfItemsInSection {
            twoDaysAfterTomorrowForecast.list.removeSubrange(NumberConstants.fromZeroToSeven)
            if twoDaysAfterTomorrowForecast.list.count > NumberConstants.numberOfItemsInSection {
                twoDaysAfterTomorrowForecast.list.removeSubrange(NumberConstants.fromEightToEnd)
                forecasts.append(twoDaysAfterTomorrowForecast)
            }
        }
    }
    
    private func compare(to date: TimeInterval) -> Bool {
        let day = Date()
        let nextDay = Date(timeIntervalSince1970: date)
        
        if dayToString(from: day) == dayToString(from: nextDay) {
            return false
        } else {
            return true
        }
    }
    
    private func dayToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = StringConstants.dateFormat
        
        return dateFormatter.string(from: date)
    }
    
    mutating func emptyForecast() {
        forecast = nil
        forecasts.removeAll()
    }
}

private enum NumberConstants {
    static let numberOfItemsInSection = 8
    static let fromZeroToSeven = 0...7
    static let fromEightToEnd = 8...
}

private enum StringConstants {
    static let dateFormat = "dd"
}
