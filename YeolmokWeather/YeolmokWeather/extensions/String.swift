//
//  String.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/12/13.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
