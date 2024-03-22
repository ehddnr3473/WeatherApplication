//
//  WeatherViewController.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/12/17.
//

import Foundation

protocol WeatherControllable: AnyObject {
    associatedtype Model
    
    var model: Model { get set }
    var weatherNetworkService: WeatherNetworkService { get }
}
