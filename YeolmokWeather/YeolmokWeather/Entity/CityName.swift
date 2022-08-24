//
//  Korean.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/07.
//

import Foundation

struct CityName: Codable {
    let name: String
    let koreanNameOfCity: KoreanNameOfCity
    
    struct KoreanNameOfCity: Codable {
        let cityName: String?
        let ascii: String?
        
        enum CodingKeys: String, CodingKey {
            case cityName = "ko"
            case ascii
        }
    }
        
    enum CodingKeys: String, CodingKey {
        case name
        case koreanNameOfCity = "local_names"
    }
}
