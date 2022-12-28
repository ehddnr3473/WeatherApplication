//
//  AnotherCities.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/11/06.
//

import Foundation


/// Other Cities Model
struct OtherCities {
    var cities = [AnotherCity]()
    
    var isEmpty: Bool {
        cities.isEmpty
    }
    
    var count: Int {
        cities.count
    }
    
    func verifyContains(with cityName: String) -> Bool {
        cities.contains(where: { $0.name == cityName })
    }
    
    mutating func appendCity(_ city: AnotherCity) {
        cities.append(city)
    }
    
    mutating func removeCity(at index: Int) {
        cities.remove(at: index)
    }
}
