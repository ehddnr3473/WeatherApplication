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
        let otherCitiesViewController = OtherCitiesViewController()
        
        currentWeatherViewController.tabBarItem = UITabBarItem(title: TitleConstants.weather, image: UIImage(systemName: ImageName.weather), tag: NumberConstants.first)
        otherCitiesViewController.tabBarItem = UITabBarItem(title: TitleConstants.city, image: UIImage(systemName: ImageName.city), tag: NumberConstants.second)
        
        viewControllers = [currentWeatherViewController, otherCitiesViewController]
        setViewControllers(viewControllers, animated: true)

        tabBar.tintColor = AppStyles.Colors.mainColor
        tabBar.unselectedItemTintColor = .gray
    }
}

private enum TitleConstants {
    static let weather = "Weather".localized
    static let city = "City".localized
}

private enum ImageName {
    static let weather = "sun.max.circle.fill"
    static let city = "plus.circle.fill"
}

private enum NumberConstants {
    static let first = 0
    static let second = 1
}
