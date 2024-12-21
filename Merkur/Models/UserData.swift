//
//  UserData.swift
//  Merkur
//
//  Created by Alex on 19.12.2024.
//

import Foundation

struct UserData: Codable {
    var coins: Int
    var wave: Int
    var purchasedAbilities: PurchasedAbilities
    var unlockedAchievements: Set<String>
    
    static let empty = UserData(
        coins: 0,
        wave: 0,
        purchasedAbilities: .empty,
        unlockedAchievements: []
    )
}
