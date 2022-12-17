//
//  LocalizationTests.swift
//  YeolmokWeatherTests
//
//  Created by 김동욱 on 2022/12/17.
//

import XCTest
@testable import YeolmokWeather

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
