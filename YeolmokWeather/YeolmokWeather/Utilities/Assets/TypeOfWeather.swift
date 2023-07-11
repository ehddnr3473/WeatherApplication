//
//  Weather.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/03.
//

import Foundation

enum TypeOfWeather {
    enum BackgroundImage: String, CaseIterable {
        case clear = "Clear"
        case cloudy = "Clouds"
        case thunder = "Thunder"
        case rainy = "Rainy"
        case snow = "Snow"
        case mist = "Mist"
        case tornado = "Tornado"
        case squalls = "Squalls"
        case dust = "Dust"
        case volcanicAsh = "VolcanicAsh"
        case cold = "Cold"
        case hot = "Hot"
        case windy = "Windy"
        case hail = "Hail"
    }
    
    enum ForecastImage: String, CaseIterable {
        case clear = "ClearIcon"
        case cloudy = "CloudsIcon"
        case thunder = "ThunderIcon"
        case rainy = "RainyIcon"
        case snow = "SnowIcon"
        case mist = "MistIcon"
        case tornado = "TornadoIcon"
        case squalls = "SquallsIcon"
        case dust = "DustIcon"
        case volcanicAsh = "VolcanicAshIcon"
        case cold = "ColdIcon"
        case hot = "HotIcon"
        case windy = "WindyIcon"
        case hail = "HailIcon"
    }
}
