//
//  Storeable.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/12/18.
//

import Foundation

/// Core Data
protocol Storeable: AnyObject {
    var storedCities: [String] { get set }
    
    func fetchBookmarkCity(request: (String) -> Void)
}

extension Storeable {
    // Fetch Core Data & Request Weather Data
    func fetchBookmarkCity(request: (String) -> Void) {
        guard let resultArray = BookmarkManager.fetchCity() else { return }
        for index in resultArray.indices {
            guard let cityName = resultArray[index].value(forKey: CoreDataModel.attributeName) as? String else { return }
            storedCities.append(cityName)
            request(cityName)
        }
    }
}
