//
//  Alert.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/12/02.
//

import Foundation
import UIKit

extension UIViewController {
    @MainActor
    func alertWillAppear(_ alert: UIAlertController, _ message: String) {
        if !alert.isBeingPresented {
            alert.message = message
            present(alert, animated: true, completion: nil)
        }
    } // Alert 띄우는 메서드
}
