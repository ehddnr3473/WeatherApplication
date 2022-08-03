//
//  WeatherId.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/03.
//

import Foundation

struct WeatherId: Codable {
    let description: Description
    struct Description: Codable {
        let id: Int
        let label: String
    }
}
