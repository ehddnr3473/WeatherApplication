//
//  AnotherCities.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/11/06.
//

import Foundation

struct OtherCities {
    private(set) var cities = [AnotherCity]()
    
    func isContains(_ cityName: String) -> Bool {
        cities.contains(where: { $0.name == cityName })
    }
    
    mutating func appendCity(_ city: AnotherCity) {
        cities.append(city)
    }
    
    mutating func removeCity(at index: Int) {
        cities.remove(at: index)
    }
}
