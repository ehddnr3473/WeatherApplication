//
//  NetworkTaskTests.swift
//  YeolmokWeatherTests
//
//  Created by 김동욱 on 2022/12/16.
//

import XCTest
import CoreLocation
@testable import YeolmokWeather

final class NetworkTaskTests: XCTestCase {

    var networkManager: NetworkManager!
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
    
    override func setUp() {
        let networkManager = NetworkManager()
        self.networkManager = networkManager
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testGetReverseGeocodingURL() {
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(111.111), longitude: CLLocationDegrees(222.222))
        let url = networkManager.getReverseGeocodingURL(with: location)
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://api.openweathermap.org/geo/1.0/reverse?lat=111.111&lon=222.222&appid=\(apiKey)")
    }
    
    func testGetCurrentWeatherURL() {
        let url = networkManager.getCurrentWeatherURL(with: "seoul")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://api.openweathermap.org/data/2.5/weather?q=seoul&lang=kr&appid=\(apiKey)&units=metric")
    }
    
    func testGetForecastURL() {
        let url = networkManager.getForecastURL(with: "seoul")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://api.openweathermap.org/data/2.5/forecast?q=seoul&lang=kr&appid=\(apiKey)&units=metric")
    }
    
    func testRequestData() {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
