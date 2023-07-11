//
//  ForecastImageNameProvider.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/11.
//

import Foundation

struct ForecastImageNameProvider {
    static func get(weather: Int) -> String {
        typealias WeatherImage = TypeOfWeather.ForecastImage
        switch weather {
        case 200...232:
            return WeatherImage.thunder.rawValue
        case 300...531:
            return WeatherImage.rainy.rawValue
        case 600...622:
            return WeatherImage.snow.rawValue
        case 701...721:
            return WeatherImage.mist.rawValue
        case 731:
            return WeatherImage.dust.rawValue
        case 741:
            return WeatherImage.mist.rawValue
        case 751...761:
            return WeatherImage.dust.rawValue
        case 762:
            return WeatherImage.volcanicAsh.rawValue
        case 771...781:
            return WeatherImage.squalls.rawValue
        case 800:
            return WeatherImage.clear.rawValue
        case 801...804:
            return WeatherImage.cloudy.rawValue
        case 900...902:
            return WeatherImage.squalls.rawValue
        case 903:
            return WeatherImage.cold.rawValue
        case 904:
            return WeatherImage.hot.rawValue
        case 905:
            return WeatherImage.windy.rawValue
        case 906:
            return WeatherImage.hail.rawValue
        case 951...956:
            return WeatherImage.clear.rawValue
        case 957...962:
            return WeatherImage.squalls.rawValue
        default:
            return WeatherImage.clear.rawValue
        }
    }
}
