//
//  LocationService.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/12/17.
//

import Foundation
import CoreLocation

/// CoreLocation-related protocol
protocol LocationService: AnyObject {
    var locationManager: CLLocationManager { get }
    
    func requestAuthorization()
}

extension LocationService {
    func requestAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
    }
}
