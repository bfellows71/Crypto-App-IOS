//
//  ApiCaller.swift
//  Crypto-App
//
//  Created by Fellows, Bryce A (fello005) on 4/4/24.
//

import Foundation
import Combine

// loading the crypto data to be used
struct CryptoData: Codable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let total_volume: Int
    let price_change_percentage_24h: Double
    let low_24h: Double
    let high_24h: Double
    let image: String
    


    
    // define keys used for encoding. used when working with json. wont work otherwise
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, total_volume, price_change_percentage_24h, low_24h, high_24h, image
        case currentPrice = "current_price"
    }
}





