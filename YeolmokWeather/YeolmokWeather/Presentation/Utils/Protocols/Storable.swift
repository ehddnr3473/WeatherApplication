//
//  Storable.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/12/18.
//

import Foundation

/// Core Data
protocol Storable: AnyObject {
    var storedCities: [String] { get set }
    
    func fetchBookmarkCity(request: (String) -> Void)
}

extension Storable {
    // Fetch stored data & Request weather data.
    func fetchBookmarkCity(request: (String) -> Void) {
        guard let resultArray = BookmarkService.fetchCity() else { return }
        for index in resultArray.indices {
            guard let cityName = resultArray[index].value(forKey: CoreDataModel.attributeName) as? String else { return }
            storedCities.append(cityName)
            request(cityName)
        }
    }
}
