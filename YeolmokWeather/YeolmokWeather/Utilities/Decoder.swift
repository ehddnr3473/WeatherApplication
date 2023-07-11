//
//  Decoder.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/04.
//

import Foundation

struct Decoder {
    static func decode<T: Decodable>(with data: Data, modelType: T.Type) -> T? {
        let decoder = JSONDecoder()
        let result = try? decoder.decode(T.self, from: data)
        return result
    }
}
