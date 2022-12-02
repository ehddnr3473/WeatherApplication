//
//  FetchTimeText.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/11.
//

import Foundation

enum AppText {
    static let weatherTitle = "Weather"
    static let cityTitle = "City"
    static let weatherIcon = "sun.max.circle.fill"
    static let cityIcon = "plus.circle.fill"
    static let celsiusString = "℃"
    static let pattern = "^[A-Za-z]{0,}$"
    static let dateFormat = "dd"
    
    enum ModelText {
        static let entityName = "City"
        static let attributeName = "name"
    }
    
    enum AlertTitle {
        static let error = "오류"
        static let appendFail = "추가 실패"
    }
}
