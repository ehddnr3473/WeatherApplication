//
//  FetchImageName.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/11.
//

import Foundation

/// 날씨 아이콘 및 배경 이미지 이름 반환
struct FetchImageName {
    static func setForecastImage(weather: Int) -> String {
        switch weather {
        case 200...232:
            return TypeOfWeather.forecastImage.thunder
        case 300...531:
            return TypeOfWeather.forecastImage.rainy
        case 600...622:
            return TypeOfWeather.forecastImage.snow
        case 701...721:
            return TypeOfWeather.forecastImage.mist
        case 731:
            return TypeOfWeather.forecastImage.dust
        case 741:
            return TypeOfWeather.forecastImage.mist
        case 751...761:
            return TypeOfWeather.forecastImage.dust
        case 762:
            return TypeOfWeather.forecastImage.volcanicAsh
        case 771...781:
            return TypeOfWeather.forecastImage.squalls
        case 800:
            return TypeOfWeather.forecastImage.clear
        case 801...804:
            return TypeOfWeather.forecastImage.cloudy
        case 900...902:
            return TypeOfWeather.forecastImage.squalls
        case 903:
            return TypeOfWeather.forecastImage.cold
        case 904:
            return TypeOfWeather.forecastImage.hot
        case 905:
            return TypeOfWeather.forecastImage.windy
        case 906:
            return TypeOfWeather.forecastImage.hail
        case 951...956:
            return TypeOfWeather.forecastImage.clear
        case 957...962:
            return TypeOfWeather.forecastImage.squalls
        default:
            return TypeOfWeather.forecastImage.clear
        }
    }
    
    static func setUpBackgroundImage(weather: Int) -> String {
        switch weather {
        case 200...232:
            return TypeOfWeather.backgroundImage.thunder
        case 300...531:
            return TypeOfWeather.backgroundImage.rainy
        case 600...622:
            return TypeOfWeather.backgroundImage.snow
        case 701...721:
            return TypeOfWeather.backgroundImage.mist
        case 731:
            return TypeOfWeather.backgroundImage.dust
        case 741:
            return TypeOfWeather.backgroundImage.mist
        case 751...761:
            return TypeOfWeather.backgroundImage.dust
        case 762:
            return TypeOfWeather.backgroundImage.volcanicAsh
        case 771...781:
            return TypeOfWeather.backgroundImage.squalls
        case 800:
            return TypeOfWeather.backgroundImage.clear
        case 801...804:
            return TypeOfWeather.backgroundImage.cloudy
        case 900...902:
            return TypeOfWeather.backgroundImage.squalls
        case 903:
            return TypeOfWeather.backgroundImage.cold
        case 904:
            return TypeOfWeather.backgroundImage.hot
        case 905:
            return TypeOfWeather.backgroundImage.windy
        case 906:
            return TypeOfWeather.backgroundImage.hail
        case 951...956:
            return TypeOfWeather.backgroundImage.clear
        case 957...962:
            return TypeOfWeather.backgroundImage.squalls
        default:
            return TypeOfWeather.backgroundImage.clear
        }
    }
}
