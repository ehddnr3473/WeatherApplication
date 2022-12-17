//
//  SearchUITests.swift
//  YeolmokWeatherUITests
//
//  Created by 김동욱 on 2022/12/17.
//

import XCTest

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
        

        let result = app.staticTexts["London"]
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
        searchField.typeText("")
        
        let searchButton = app.keyboards.buttons["Search"]
        XCTAssert(searchButton.isHittable)
        
        searchButton.tap()

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
        
        let firstResult = app.staticTexts["Seoul"]
        XCTAssert(firstResult.isHittable)
        
        searchField.tap()
        searchField.typeText("seoul")
        searchButton.tap()
        
        let secondResult = app.staticTexts["이미 추가된 도시입니다."]
        XCTAssert(secondResult.isHittable)
    }
}
