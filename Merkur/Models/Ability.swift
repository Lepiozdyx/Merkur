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
    case timeShift
    
    var price: Int {
        switch self {
        case .shield: return Constants.Shop.shieldPrice
        case .meteorDestruction: return Constants.Shop.meteorDestructionPrice
        case .timeShift: return Constants.Shop.timeShiftPrice
        }
    }
    
    var image: ImageResource {
        switch self {
        case .shield: return .shield
        case .meteorDestruction: return .destroyer
        case .timeShift: return .time
        }
    }
    
    var abilityName: String {
        switch self {
        case .shield: return "SHIELD"
        case .meteorDestruction: return "METEOR DESTROYER"
        case .timeShift: return "TIME SHIFT"
        }
    }
    
    var abilityDescription: String {
        switch self {
        case .shield:
            return "5-second Planetary Shield"
        case .meteorDestruction:
            return "Destroy all meteors on screen"
        case .timeShift:
            return "Activate time shift mode"
        }
    }
}

struct Ability: Identifiable {
    let id = UUID()
    let type: AbilityType
    var count: Int
    var isActive: Bool
}
