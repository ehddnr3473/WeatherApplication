//
//  FetchTimeText.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/11.
//

import Foundation

struct AppText {
    static let weatherTitle = "Weather"
    static let cityTitle = "City"
    static let weatherIcon = "sun.max.circle.fill"
    static let cityIcon = "plus.circle.fill"
    static let celsiusString = "℃"
    static let pattern = "^[A-Za-z]{0,}$"
    static let dateFormat = "dd"
    
    struct ModelText {
        static let entityName = "City"
        static let attributeName = "name"
    }
    
    struct AlertTitle {
        static let error = "오류"
        static let appendFail = "추가 실패"
    }
    
    struct AlertMessage {
        static let appendFailMessage = "이미 추가된 도시입니다."
        static let emptyText = "도시명을 입력해주세요."
        static let denied = "애플리케이션을 실행하기 위해서는 위치 정보 제공이 필요합니다. 설정 > 열목날씨 > 위치에서 애플리케이션의 위치 사용 설정을 허용해주시기를 바랍니다."
        static let restricted = "보호자 통제와 같은 활성화 제한으로 인해 사용자가 애플리케이션의 상태를 변경할 수 없습니다."
        static let undefined = "알 수 없는 오류가 발생하였습니다."
        static let fail = "위치 설정 오류가 발생하였습니다."
    }
}
