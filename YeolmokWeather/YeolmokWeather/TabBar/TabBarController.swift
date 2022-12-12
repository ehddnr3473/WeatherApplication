//
//  TabBarController.swift
//  YeolmokWeather
//
//  Created by 김동욱 on 2022/10/04.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp() {
        let currentWeatherViewController = CurrentWeatherViewController()
        let otherCityViewController = OtherCityViewController()
        
        currentWeatherViewController.tabBarItem = UITabBarItem(title: TitleConstants.weather, image: UIImage(systemName: ImageName.weather), tag: NumberConstants.first)
        otherCityViewController.tabBarItem = UITabBarItem(title: TitleConstants.city, image: UIImage(systemName: ImageName.city), tag: NumberConstants.second)
        
        viewControllers = [currentWeatherViewController, otherCityViewController]
        setViewControllers(viewControllers, animated: true)

        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .black
    }
}

private enum TitleConstants {
    static let weather = "Weather"
    static let city = "City"
}

private enum ImageName {
    static let weather = "sun.max.circle.fill"
    static let city = "plus.circle.fill"
}

private enum NumberConstants {
    static let first = 0
    static let second = 1
}
