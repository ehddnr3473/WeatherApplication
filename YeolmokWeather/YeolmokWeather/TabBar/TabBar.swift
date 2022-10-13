//
//  TabBar.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/10/04.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp() {
        let currentWeatherViewController = CurrentWeatherViewController()
        let otherCityViewController = OtherCityViewController()
        
        currentWeatherViewController.tabBarItem = UITabBarItem(title: AppText.weatherTitle, image: UIImage(systemName: AppText.weatherIcon), tag: NumberConstants.first)
        otherCityViewController.tabBarItem = UITabBarItem(title: AppText.cityTitle, image: UIImage(systemName: AppText.cityIcon), tag: NumberConstants.second)
        
        viewControllers = [currentWeatherViewController, otherCityViewController]
        setViewControllers(viewControllers, animated: true)

        tabBar.tintColor = .white
    }
}

private struct NumberConstants {
    static let first = 0
    static let second = 1
}
