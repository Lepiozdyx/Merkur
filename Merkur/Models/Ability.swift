//
//  Ability.swift
//  Merkur
//
//  Created by Alex on 17.12.2024.
//

import Foundation

enum AbilityType: String, CaseIterable, Codable {
    case shield
    case meteorDestruction
    case penaltyCancel
    
    var price: Int {
        switch self {
        case .shield: return Constants.Shop.shieldPrice
        case .meteorDestruction: return Constants.Shop.meteorDestructionPrice
        case .penaltyCancel: return Constants.Shop.penaltyCancelPrice
        }
    }
    
    var image: String {
        switch self {
        case .shield: return "shield"
        case .meteorDestruction: return "destroyer"
        case .penaltyCancel: return "time"
        }
    }
}

struct Ability: Identifiable {
    let id = UUID()
    let type: AbilityType
    var count: Int
    var isActive: Bool
}
