//
//  Forecast.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/09.
//

import Foundation

struct Forecast: Codable {
    var list: [List]
    var city: City
    struct List: Codable {
        let date: TimeInterval
        let main: Main
        let weather: [Weather]
        let rain: Rain?
        
        struct Main: Codable {
            let temp: Double
        }
        
        struct Weather: Codable {
            let id: Int
            let main: String
            let description: String
        }
        
        struct Rain: Codable {
            let rainVolumeForLastThreeHours: Double?
            
            enum CodingKeys: String, CodingKey  {
                case rainVolumeForLastThreeHours = "3h"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main
            case weather
            case rain
        }
    }
    
    struct City: Codable {
        let name: String
    }
}
