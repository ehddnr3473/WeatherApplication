//
//  FetchTimeText.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/11.
//

import Foundation

struct FetchTimeText {
    static func getTimeText(time: String) -> String {
        var result: String
        var temp: Int
        let startIndex = time.index(time.startIndex, offsetBy: 11)
        let endIndex = time.index(time.endIndex, offsetBy: -7)
        temp = Int(String(time[startIndex...endIndex]))!
        
        if temp < 12 {
            result = "오전 "
        } else {
            result = "오후 "
        }
        
        if temp == 0 {
            temp = 12
        } else if temp > 12 {
            temp -= 12
        }
        
        result += String(temp) + "시"
        
        return result
    }
}
