//
//  StorageManager.swift
//  Merkur
//
//  Created by Alex on 18.12.2024.
//

import Foundation

enum StorageKey: String {
    case coins = "userCoins"
    case highestRound = "highestCompletedRound"
    case abilities = "purchasedAbilities"
}

@MainActor
final class StorageManager {
    static let shared = StorageManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Coins Management
    func getCoins() -> Int {
        defaults.integer(forKey: StorageKey.coins.rawValue)
    }
    
    func saveCoins(_ coins: Int) {
        defaults.set(coins, forKey: StorageKey.coins.rawValue)
    }
    
    func addCoins(_ amount: Int) {
        let current = getCoins()
        saveCoins(current + amount)
    }
    
    // MARK: - Round Management
    func getHighestCompletedRound() -> Int {
        defaults.integer(forKey: StorageKey.highestRound.rawValue)
    }
    
    func saveHighestCompletedRound(_ round: Int) {
        let current = getHighestCompletedRound()
        if round > current {
            defaults.set(round, forKey: StorageKey.highestRound.rawValue)
        }
    }
    
    // MARK: - Abilities Management
    func saveAbilities(_ abilities: [AbilityType: Int]) {
        let encoded = try? JSONEncoder().encode(abilities)
        defaults.set(encoded, forKey: StorageKey.abilities.rawValue)
    }
    
    func getAbilities() -> [AbilityType: Int] {
        guard let data = defaults.data(forKey: StorageKey.abilities.rawValue),
              let abilities = try? JSONDecoder().decode([AbilityType: Int].self, from: data)
        else {
            return [:]
        }
        return abilities
    }
}
