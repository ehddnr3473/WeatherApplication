//
//  TodayWeatherForecastCollectionViewDelegate.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/12.
//

import Foundation
import UIKit

class TodayWeatherForecastCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 150)
    }
}
