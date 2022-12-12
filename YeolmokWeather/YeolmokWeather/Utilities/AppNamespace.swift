//
//  AppLayerConfiguration.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/17.
//

import Foundation
import UIKit

enum AppStyles {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1
    
    enum Colors {
        static let mainColor = UIColor.white
        static let backgroundColor = UIColor.clear.withAlphaComponent(0.5)
    }
}

enum AppText {
    static let celsiusString = String(UnicodeScalar(0x00002103)!)
    static var language: String {
        if Locale.current.languageCode == "ko" {
            return "kr"
        } else {
            return "en"
        }
    }
}
