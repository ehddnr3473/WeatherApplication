//
//  Weather++Bundle.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/02.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "WeatherInfo", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return ""}
        guard let key = resource["API_KEY"] as? String else { fatalError("WeatherInfo에 API_KEY를 설정해주세요.")}
        
        return key
    }
}
