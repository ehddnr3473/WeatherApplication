//
//  AnotherCity.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/11/06.
//

import Foundation

/// Cell에 표시할 각 도시의 날씨 정보
/// Other City Model Entity
struct AnotherCity {
    let name: String
    var currentWeather: WeatherOfCity?
    var forecastWeather: Forecast?
}
