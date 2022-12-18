//
//  LocalizationTests.swift
//  YeolmokWeatherTests
//
//  Created by 김동욱 on 2022/12/17.
//

import XCTest
@testable import YeolmokWeather

/// 현지화가 잘 적용되었는지 English 및 Korean configuration으로 확인하는 테스트 케이스
final class LocalizationTests: XCTestCase {
    
    func testLocalizedTextInCurrentWeather() {
        let viewController = CurrentWeatherViewController()
        XCTAssertEqual(viewController.titleLabel.text?.localized, "Forecast".localized)
        XCTAssertEqual(viewController.alert.title, "AlertTitle".localized)
        XCTAssertEqual(viewController.alert.actions[.zero].title, "ActionTitle".localized)
    }
    
    func testLocalizedTextInOtherCities() {
        let viewController = OtherCitiesViewController()
        XCTAssertEqual(viewController.titleLabel.text, "City weather".localized)
        XCTAssertEqual(viewController.searchTextField.placeholder, "Placeholder".localized)
        XCTAssertEqual(viewController.cancelButton.titleLabel?.text, "Cancel".localized)
        XCTAssertEqual(viewController.alert.title, "AlertTitle".localized)
        XCTAssertEqual(viewController.alert.actions[.zero].title, "ActionTitle".localized)
    }
}
