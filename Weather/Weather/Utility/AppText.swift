//
//  FetchTimeText.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/11.
//

import Foundation

struct AppText {
    static let celsiusString: String = "℃"
    
    static func getTimeText(time: String) -> String {
        var result: String
        var hour: Int
        let startIndex = time.index(time.startIndex, offsetBy: 11)
        let endIndex = time.index(time.endIndex, offsetBy: -7)
        hour = Int(String(time[startIndex...endIndex]))!
        
        if hour < 12 {
            result = "오전 "
        } else {
            result = "오후 "
        }
        
        if hour == 0 {
            hour = 12
        } else if hour > 12 {
            hour -= 12
        }
        
        result += String(hour) + "시"
        
        return result
    }
}
