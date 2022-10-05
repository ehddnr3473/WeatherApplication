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
        
        currentWeatherViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        otherCityViewController.tabBarItem = UITabBarItem(title: "OtherCity", image: UIImage(systemName: "plus.circle.fill"), tag: 1)
        
        viewControllers = [currentWeatherViewController, otherCityViewController]
        setViewControllers(viewControllers, animated: true)

        tabBar.tintColor = .white
    }
}
