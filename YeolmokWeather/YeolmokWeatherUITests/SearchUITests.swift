//
//  SearchUITests.swift
//  YeolmokWeatherUITests
//
//  Created by 김동욱 on 2022/12/17.
//

import XCTest
@testable import YeolmokWeather

/// 검색 작업에 대해서 의도대로 작동하는지 확인하는 UI 테스트 케이스
final class SearchUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
    }
    
    // 정상적인 검색
    func testSearch() {
        app.tabBars.buttons["도시"].tap()
        XCTAssert(app.staticTexts["도시 날씨"].isHittable)
        
        let searchField = app.textFields["도시명을 영어로 검색"]
        XCTAssert(searchField.isHittable)
        
        searchField.tap()
        searchField.typeText("london")
        
        let searchButton = app.buttons["Search"]
        XCTAssert(searchButton.isHittable)
        
        searchButton.tap()
        
        Thread.sleep(forTimeInterval: 3)
        let result = app.staticTexts["London"]
        XCTAssert(result.isHittable)
    }
    
    func testSearchWithUppercase() {
        app.tabBars.buttons["도시"].tap()
        XCTAssert(app.staticTexts["도시 날씨"].isHittable)

        let searchField = app.textFields["도시명을 영어로 검색"]
        XCTAssert(searchField.isHittable)

        searchField.tap()
        searchField.typeText("CALIFORNIA")

        let searchButton = app.buttons["Search"]
        XCTAssert(searchButton.isHittable)

        searchButton.tap()

        Thread.sleep(forTimeInterval: 3)
        let result = app.staticTexts["California"]
        XCTAssert(result.isHittable)
    }
    
    
    // 없는 도시 이름으로 검색
    func testSearchWithWrongCityName() {
        app.tabBars.buttons["도시"].tap()
        XCTAssert(app.staticTexts["도시 날씨"].isHittable)
        
        let searchField = app.textFields["도시명을 영어로 검색"]
        XCTAssert(searchField.isHittable)
        
        searchField.tap()
        searchField.typeText("test")
        
        let searchButton = app.buttons["Search"]
        XCTAssert(searchButton.isHittable)
        
        searchButton.tap()
        
        Thread.sleep(forTimeInterval: 3)
        let result = app.staticTexts["도시 이름을 다시 확인해주세요."]
        XCTAssert(result.isHittable)
    }
    
    // 빈 문자열로 검색
    func testSearchWithEmptyText() {
        app.tabBars.buttons["도시"].tap()
        XCTAssert(app.staticTexts["도시 날씨"].isHittable)
        
        let searchField = app.textFields["도시명을 영어로 검색"]
        XCTAssert(searchField.isHittable)
        
        searchField.tap()
        app.keyboards.buttons["Search"].tap()

        let result = app.staticTexts["도시명을 입력해주세요."]
        XCTAssert(result.isHittable)
    }
    
    // 이미 추가된 도시 이름 검색
    func testDoubleSearch() {
        app.tabBars.buttons["도시"].tap()
        XCTAssert(app.staticTexts["도시 날씨"].isHittable)
        
        let searchField = app.textFields["도시명을 영어로 검색"]
        XCTAssert(searchField.isHittable)
        
        searchField.tap()
        searchField.typeText("seoul")
        
        let searchButton = app.buttons["Search"]
        XCTAssert(searchButton.isHittable)
        
        searchButton.tap()
        
        Thread.sleep(forTimeInterval: 3)
        let firstResult = app.staticTexts["Seoul"]
        XCTAssert(firstResult.isHittable)
        
        searchField.tap()
        searchField.typeText("seoul")
        searchButton.tap()
        
        let secondResult = app.staticTexts["이미 추가된 도시입니다."]
        XCTAssert(secondResult.isHittable)
    }
    
    // 즐겨찾기한 도시가 없다는 가정하에 테스트
    func testBookmark() {
        let tabBarButton = app.tabBars.buttons["도시"]
        tabBarButton.tap()
        XCTAssert(app.staticTexts["도시 날씨"].isHittable)
        
        let searchField = app.textFields["도시명을 영어로 검색"]
        XCTAssert(searchField.isHittable)
        
        searchField.tap()
        searchField.typeText("hawaii")
        
        app.buttons["Search"].tap()
        
        Thread.sleep(forTimeInterval: 3)
        let firstResult = app.staticTexts["Hawaii"]
        XCTAssert(firstResult.isHittable)
        
        let starButton = app.tables.cells.buttons["star"]
        XCTAssert(starButton.isHittable)
        
        // 즐겨찾기 등록 후, 재시동하여 잘 불러오는지 확인
        starButton.tap()
        restart()
        tabBarButton.tap()
        
        XCTAssert(app.staticTexts["Hawaii"].isHittable)
        // 즐겨찾기 삭제하여 초기 상태로.
        starButton.tap()
    }
    
    func restart() {
        app.terminate()
        app.launch()
    }
}
