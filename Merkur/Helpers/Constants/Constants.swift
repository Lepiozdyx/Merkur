//
//  Constants.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import Foundation

enum Constants {
    enum Play {
        static let countdownDuration = 2
        static let gamePlayDuration: TimeInterval = 30
        static let penaltyDuration: TimeInterval = 5
        static let coinsDroppingChance = 10
        static let initialHealth: Double = 100
        static let meteorDamage: Double = 20
    }
    
    enum Rounds {
        static let itemFallingDuration: TimeInterval = 2.5
        static let itemGenerationPeriod: TimeInterval = 0.7
        static let maxFallingItems = 40
        
        static let maxRounds = 5
        
        static let speedMultiplier: [Double] = [1.0, 1.2, 1.4, 1.6, 1.8]
        static let itemsMultiplier: [Double] = [1.0, 1.3, 1.6, 1.9, 2.2]
        
        static func getFallingDuration(for round: Int) -> TimeInterval {
            let roundIndex = max(0, min(round - 1, maxRounds - 1))
            return itemFallingDuration / speedMultiplier[roundIndex]
        }
        
        static func getGenerationPeriod(for round: Int) -> TimeInterval {
            let roundIndex = max(0, min(round - 1, maxRounds - 1))
            return itemGenerationPeriod / speedMultiplier[roundIndex]
        }
        
        static func getMaxFallingItems(for round: Int) -> Int {
            let roundIndex = max(0, min(round - 1, maxRounds - 1))
            return Int(Double(maxFallingItems) * itemsMultiplier[roundIndex])
        }
    }
    
    enum Shop {
        static let shieldPrice = 50
        static let meteorDestructionPrice = 75
        static let penaltyCancelPrice = 35
    }
    
    enum Screen {
        static let itemSize: CGFloat = 60
    }
    
    enum StorageKey: String {
        case userData = "userData"
        case coins = "userCoins"
        case highestWave = "highestCompletedWave"
        case abilities = "purchasedAbilities"
    }
    
    enum Sounds {
        static let music = "music"
    }
}
