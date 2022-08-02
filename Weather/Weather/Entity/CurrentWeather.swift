//
//  CurrentWeather.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/02.
//

import Foundation

struct Current: Codable {
    
    let coorId: CoorId
    let weather: Weather
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: Sys
    
    let base: String
    let visibility: String
    let dt: Int
    
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    struct CoorId: Codable {
        let lon: Int
        let lat: Int
    }
    // 배열?
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Int
        let feels_like: Int
        let temp_min: Int
        let temp_max: Int
        let pressure: Int
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Int
        let deg: Int
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Sys: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}
