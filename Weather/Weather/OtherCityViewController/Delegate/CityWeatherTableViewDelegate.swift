//
//  CityWeatherTableViewDelegate.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/12.
//

import Foundation
import UIKit

class CityWeatherTableViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
