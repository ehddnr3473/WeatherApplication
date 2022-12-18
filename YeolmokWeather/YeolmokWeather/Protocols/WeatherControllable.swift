//
//  WeatherViewController.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/12/17.
//

import Foundation

/// 날씨 관련 Controller
protocol WeatherControllable: AnyObject {
    associatedtype Model
    
    var model: Model { get set }
    var networkManager: NetworkManager { get }
}
