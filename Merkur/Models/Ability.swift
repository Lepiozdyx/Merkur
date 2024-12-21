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
    
    var image: ImageResource {
        switch self {
        case .shield: return .shield
        case .meteorDestruction: return .destroyer
        case .penaltyCancel: return .time
        }
    }
    
    var abilityName: String {
        switch self {
        case .shield: return "SHIELD"
        case .meteorDestruction: return "METEOR DESTROYER"
        case .penaltyCancel: return "PENALTY CANCEL"
        }
    }
    
    var abilityDescription: String {
        switch self {
        case .shield:
            return "5-second Planetary Shield"
        case .meteorDestruction:
            return "Destroy all meteors on screen"
        case .penaltyCancel:
            return "Instantly remove penalty timer"
        }
    }
}

struct Ability: Identifiable {
    let id = UUID()
    let type: AbilityType
    var count: Int
    var isActive: Bool
}
