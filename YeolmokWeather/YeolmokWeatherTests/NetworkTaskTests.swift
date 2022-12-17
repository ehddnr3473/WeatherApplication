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
    typealias FetchError = NetworkManager.FetchError
    
    var networkManager: NetworkManager!
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
    
    override func setUp() {
        let networkManager = NetworkManager()
        self.networkManager = networkManager
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
        XCTAssertEqual(url?.absoluteString, "https://api.openweathermap.org/data/2.5/weather?q=seoul&lang=\(AppText.language)&appid=\(apiKey)&units=metric")
    }
    
    func testGetForecastURL() {
        let url = networkManager.getForecastURL(with: "seoul")
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://api.openweathermap.org/data/2.5/forecast?q=seoul&lang=\(AppText.language)&appid=\(apiKey)&units=metric")
    }
    
    func testRequestData() async {
        let url = networkManager.getCurrentWeatherURL(with: "seoul")
        do {
            let data = try await networkManager.requestData(with: url!)
            XCTAssertNotNil(data)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    // API KEY 변경 후 테스트
//    func testAPIKeyError() async {
//        let url = networkManager.getCurrentWeatherURL(with: "seoul")
//        do {
//            let _ = try await networkManager.requestData(with: url!)
//        } catch {
//            XCTAssertEqual(error as? FetchError, FetchError.apiKeyError)
//        }
//    }
    
    // 맥 인터넷 끊고 테스트
//    func testInternetConnectionError() async {
//        let url = networkManager.getForecastURL(with: "seoul")
//        do {
//            let _ = try await networkManager.requestData(with: url!)
//        } catch {
//            // URLSession.shared.data(for:)에서 Error 반환
//            print("error: \(error)")
//            XCTAssertEqual(error.localizedDescription, "인터넷 연결이 오프라인 상태입니다.")
//        }
//    }
    
    func testCityNameError() async {
        let url = networkManager.getCurrentWeatherURL(with: "seoul22")
        do {
            let _ = try await networkManager.requestData(with: url!)
        } catch {
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
