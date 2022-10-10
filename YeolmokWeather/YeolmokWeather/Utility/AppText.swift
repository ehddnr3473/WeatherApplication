//
//  FetchTimeText.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/11.
//

import Foundation

struct AppText {
    static let celsiusString: String = "℃"
    static let day: String = "일"
    
    static let am: String = "오전 "
    static let pm: String = "오후 "
    static let hourString: String = "시"
    
    struct ModelText {
        static let entityName: String = "City"
        static let attributeName: String = "name"
    }
    
    struct AlertTitle {
        static let error: String = "오류"
        static let appendFail: String = "추가 실패"
    }
    
    enum AlertMessage {
        static let appendFailMessage: String = "이미 추가된 도시입니다."
        static let emptyText: String = "도시명을 입력해주세요."
        static let denied: String = "애플리케이션을 실행하기 위해서는 위치 정보 제공이 필요합니다. 설정 > 열목날씨 > 위치에서 애플리케이션의 위치 사용 설정을 허용해주시기를 바랍니다."
        static let restricted: String = "설정에서 애플리케이션의 위치 사용 설정을 허용해주시기를 바랍니다."
        static let undefined: String = "알 수 없는 오류가 발생하였습니다."
        static let fail: String = "위치 설정 오류가 발생하였습니다."
    }
    
    static func getTimeText(time: String) -> String {
        var result: String
        var hour: Int
        let startIndex = time.index(time.startIndex, offsetBy: 11)
        let endIndex = time.index(time.endIndex, offsetBy: -7)
        hour = Int(String(time[startIndex...endIndex]))!
        
        if hour < 12 {
            result = am
        } else {
            result = pm
        }
        
        if hour == 0 {
            hour = 12
        } else if hour > 12 {
            hour -= 12
        }
        
        result += String(hour) + hourString
        
        return result
    }
}
