//
//  NetworkTaskTests.swift
//  YeolmokWeatherTests
//
//  Created by 김동욱 on 2022/12/16.
//

import XCTest
import CoreLocation
@testable import YeolmokWeather

/// 네트워크 작업을 통해 날씨 데이터를 잘 받아오는지 확인하는 테스트 케이스
final class NetworkTaskTests: XCTestCase {
    typealias FetchError = WeatherNetworkService.FetchError
    
    var networkManager: WeatherNetworkService!
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
    
    override func setUp() {
        let networkManager = WeatherNetworkService()
        self.networkManager = networkManager
    }
    
    func testGetReverseGeocodingURL() {
        // given
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(111.111), longitude: CLLocationDegrees(222.222))
        
        // when
        let url = networkManager.getReverseGeocodingURL(with: location)
        
        // then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://api.openweathermap.org/geo/1.0/reverse?lat=111.111&lon=222.222&appid=\(apiKey)")
    }
    
    func testGetCurrentWeatherURL() {
        // given
        let cityName = "seoul"
        
        // when
        let url = networkManager.getCurrentWeatherURL(with: cityName)
        
        // then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString,
                       "https://api.openweathermap.org/data/2.5/weather?q=seoul&lang=\(AppText.language)&appid=\(apiKey)&units=metric")
    }
    
    func testGetForecastURL() {
        // given
        let cityName = "seoul"
        
        // when
        let url = networkManager.getForecastURL(with: cityName)
        
        // then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString,
                       "https://api.openweathermap.org/data/2.5/forecast?q=seoul&lang=\(AppText.language)&appid=\(apiKey)&units=metric")
    }
    
    func testRequestData() async {
        // given
        let url = networkManager.getCurrentWeatherURL(with: "seoul")
        do {
            // when
            let data = try await networkManager.requestData(with: url!)
            // then
            XCTAssertNotNil(data)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    // API KEY 변경 후 테스트
//    func testAPIKeyError() async {
//        let url = weatherNetworkService.getCurrentWeatherURL(with: "seoul")
//        do {
//            let _ = try await weatherNetworkService.requestData(with: url!)
//        } catch {
//            XCTAssertEqual(error as? FetchError, FetchError.apiKeyError)
//        }
//    }
    
    // 네트워크 연결 끊고 테스트
    func testInternetConnectionError() async {
        // given
        let url = networkManager.getForecastURL(with: "seoul")
        do {
            // when
            let _ = try await networkManager.requestData(with: url!)
        } catch {
            // then
            // URLSession.shared.data(for:)에서 Error 반환
            print("error: \(error)")
            XCTAssertEqual(error.localizedDescription, "인터넷 연결이 오프라인 상태입니다.")
        }
    }
    
    func testCityNameError() async {
        // given
        let url = networkManager.getCurrentWeatherURL(with: "seoul22")
        do {
            // when
            let _ = try await networkManager.requestData(with: url!)
        } catch {
            // then
            XCTAssertEqual(error as? FetchError, FetchError.cityNameError)
        }
    }
    
    func testErrorMessages() {
        for error in FetchError.allCases {
            switch error {
            case FetchError.apiKeyError:
                XCTAssertEqual(networkManager.errorMessage(error), "ApiKeyError".localized)
            case FetchError.cityNameError:
                XCTAssertEqual(networkManager.errorMessage(error), "CityNameError".localized)
            case FetchError.internetConnectionProblem:
                XCTAssertEqual(networkManager.errorMessage(error), "InternetConnectionProblem".localized)
            case FetchError.undefined:
                XCTAssertEqual(networkManager.errorMessage(error), "Undefined".localized)
            }
        }
    }
}
