//
//  Constants.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import Foundation

enum Constants {
    enum Game {
        static let initialHealth: Double = 100
        static let meteorDamage: Double = 10
        static let gameTime: Double = 30
        static let penaltyTime: Double = 5
        
        enum Rounds {
            static let maxRounds = 5
            static let itemSpeedMultiplier: [Double] = [1.0, 1.2, 1.4, 1.6, 1.8]
            static let meteorCountMultiplier: [Double] = [1.0, 1.3, 1.6, 1.9, 2.2]
            static let baseItemSpeed: Double = 150 // points per second
            static let baseMeteorCount = 15
        }
    }
    
    enum Shop {
        static let shieldPrice = 10
        static let meteorDestructionPrice = 50
        static let penaltyCancelPrice = 15
    }
}
