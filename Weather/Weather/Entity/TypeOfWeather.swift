//
//  Weather.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/03.
//

import Foundation

struct TypeOfWeather {
    static let backgroundImage = BackgroundImage()
    static let forecastImage = ForecastImage()
    
    struct BackgroundImage {
        let clear: String = "Clear"
        let cloudy: String = "Clouds"
        let thunder: String = "Thunder"
        let rainy: String = "Rainy"
        let snow: String = "Snow"
        let mist: String = "Mist"
        let tornado: String = "Tornado"
        let squalls: String = "Squalls"
        let dust: String = "Dust"
        let volcanicAsh: String = "VolcanicAsh"
        let cold: String = "Cold"
        let hot: String = "Hot"
        let windy: String = "Windy"
        let hail: String = "Hail"
    }
    
    struct ForecastImage {
        let clear: String = "ClearIcon"
        let cloudy: String = "CloudsIcon"
        let thunder: String = "ThunderIcon"
        let rainy: String = "RainyIcon"
        let snow: String = "SnowIcon"
        let mist: String = "MistIcon"
        let tornado: String = "TornadoIcon"
        let squalls: String = "SquallsIcon"
        let dust: String = "DustIcon"
        let volcanicAsh: String = "VolcanicAshIcon"
        let cold: String = "ColdIcon"
        let hot: String = "HotIcon"
        let windy: String = "WindyIcon"
        let hail: String = "HailIcon"
    }
}
