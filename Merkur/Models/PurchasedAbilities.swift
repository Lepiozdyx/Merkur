//
//  PurchasedAbilities.swift
//  Merkur
//
//  Created by Alex on 21.12.2024.
//

import Foundation

struct PurchasedAbilities: Codable {
    var abilities: [AbilityType: Int]
    
    static let empty = PurchasedAbilities(abilities: [:])
    
    mutating func addAbility(_ type: AbilityType) {
        abilities[type] = (abilities[type] ?? 0) + 1
    }
    
    mutating func useAbility(_ type: AbilityType) {
        guard let count = abilities[type], count > 0 else { return }
        abilities[type] = count - 1
    }
    
    func getCount(for type: AbilityType) -> Int {
        abilities[type] ?? 0
    }
}
