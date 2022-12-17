//
//  LocationService.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/12/17.
//

import Foundation
import CoreLocation

protocol LocationService {
    var locationManager: CLLocationManager { get }
    var currentLocation: CLLocationCoordinate2D? { get set }
    
    func requestAuthorization()
}

extension LocationService {
    func requestAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
    }
}
